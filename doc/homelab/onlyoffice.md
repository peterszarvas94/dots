# ONLYOFFICE (Nextcloud)

In-browser Word/Excel/PowerPoint for Nextcloud via ONLYOFFICE Document Server.

**Users:** no ONLYOFFICE accounts. Existing Nextcloud users open files from Files as usual.

Public Caddy `office.erdohat.com` → local `9980` — see [custom-domains.md](./custom-domains.md).

## Ports

| Public hostname | Local | Service |
|---------------|-------|---------|
| `drive.erdohat.com` | `8081` | Nextcloud |
| `office.erdohat.com` | `9980` | ONLYOFFICE Document Server |

## Why split URLs?

Nextcloud in Docker should not call its own Funnel URL for server-to-server traffic.

| Direction | URL |
|-----------|-----|
| Browser → Document Server | `https://office.erdohat.com` |
| Nextcloud → Document Server | `http://onlyoffice/` (container name on `nextcloud_default`) |
| Document Server → Nextcloud | `http://nextcloud.wopi.local/` (Docker DNS alias on the Nextcloud app) |

The `nextcloud.wopi.local` alias is defined in [nextcloud.md](./nextcloud.md) (`networks:` on the app service). Do **not** use `http://172.20.0.1:8081` from containers — Docker hairpin to the published port fails.

## 1. Create directories

```bash
sudo install -d -o homelab -g homelab -m 755 /home/homelab/onlyoffice
```

## 2. Create `.env`

```bash
sudoedit /home/homelab/onlyoffice/.env
```

```dotenv
# Same secret in Document Server and Nextcloud ONLYOFFICE app (JWT)
JWT_SECRET=PUT_LONG_RANDOM_SECRET_HERE
TZ=Europe/Budapest
```

Generate a secret, e.g. `openssl rand -base64 24`.

## 3. Create `docker-compose.yml`

```bash
sudoedit /home/homelab/onlyoffice/docker-compose.yml
```

```yaml
name: onlyoffice

services:
  onlyoffice:
    image: onlyoffice/documentserver:latest
    container_name: onlyoffice
    restart: always
    ports:
      - "9980:80"
    environment:
      JWT_ENABLED: "true"
      JWT_SECRET: ${JWT_SECRET}
      ALLOW_PRIVATE_IP_ADDRESS: "true"
      TZ: ${TZ}
    networks:
      - nextcloud_default

networks:
  nextcloud_default:
    external: true
```

`ALLOW_PRIVATE_IP_ADDRESS=true` lets the document server call `http://nextcloud.wopi.local` (private RFC1918 / Docker addresses).

## 4. Ownership

```bash
sudo chown homelab:homelab /home/homelab/onlyoffice/.env /home/homelab/onlyoffice/docker-compose.yml
sudo chmod 600 /home/homelab/onlyoffice/.env
```

## 5. Start ONLYOFFICE

```bash
sudo -u homelab docker compose -f /home/homelab/onlyoffice/docker-compose.yml --env-file /home/homelab/onlyoffice/.env up -d
sudo -u homelab docker compose -f /home/homelab/onlyoffice/docker-compose.yml --env-file /home/homelab/onlyoffice/.env ps
```

Health: `curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:9980/healthcheck` → `200`.

## 6. Funnel

Caddy on `hal` proxies `office.erdohat.com` to Asimov port `9980`; see [custom-domains.md](./custom-domains.md).

## 7. Nextcloud app

1. **Apps** → search **ONLYOFFICE** → enable.
2. **Administration → ONLYOFFICE**:
   - **Document Editing Service address:** `https://office.erdohat.com`
   - **Secret key (JWT):** same as `JWT_SECRET` in `.env`
   - **Advanced → Document Editing Service address for internal requests:** `http://onlyoffice/`
   - **Advanced → Server address for internal requests from the document editing service:** `http://nextcloud.wopi.local/`

Or via `occ` (replace placeholders):

```bash
sudo docker exec -u www-data nextcloud_app php occ config:app:set onlyoffice DocumentServerUrl --value='https://office.erdohat.com'
sudo docker exec -u www-data nextcloud_app php occ config:app:set onlyoffice DocumentServerInternalUrl --value='http://onlyoffice/'
sudo docker exec -u www-data nextcloud_app php occ config:app:set onlyoffice StorageUrl --value='http://nextcloud.wopi.local/'
sudo docker exec -u www-data nextcloud_app php occ config:app:set onlyoffice jwt_secret --value='PUT_LONG_RANDOM_SECRET_HERE'
```

## 8. Verify

```bash
sudo docker exec -u www-data nextcloud_app php occ onlyoffice:documentserver --check
```

Expect: document server version … **successfully connected**.

From the document server container:

```bash
sudo docker exec onlyoffice curl -s -o /dev/null -w '%{http_code}\n' http://nextcloud.wopi.local/status.php
```

Expect: `200`.

Open a `.docx` / `.xlsx` from **Files**.

## 9. Restart

```bash
sudo -u homelab docker compose -f /home/homelab/onlyoffice/docker-compose.yml --env-file /home/homelab/onlyoffice/.env restart
```

After changing `JWT_SECRET`, update both `.env` and Nextcloud app settings, then recreate or restart the container.

## Troubleshooting

**“Document server … failed to connect”**

- Caddy on `hal` must route `office.erdohat.com` to Asimov `:9980`.
- JWT secret must match in `.env` and Nextcloud.
- `onlyoffice` container must be on `nextcloud_default`: `docker inspect onlyoffice --format '{{json .NetworkSettings.Networks}}'`.

**Editor loads but cannot save / download**

- Set **StorageUrl** / internal Nextcloud URL to `http://nextcloud.wopi.local/` (not Funnel, not `nextcloud_app`, not gateway IP).
- Confirm alias exists on `nextcloud_app` and `curl` from `onlyoffice` to `status.php` returns 200.

**Still slow**

- The public editor uses `https://office.erdohat.com`; internal Docker callbacks continue using the Docker URLs above.
