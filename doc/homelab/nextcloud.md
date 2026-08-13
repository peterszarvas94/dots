# Nextcloud

Google Drive / Docs / Calendar / Contacts alternative. Owned by `homelab`.

Assumes [immich.md](./immich.md) already created `homelab`, Docker, and Tailscale. Skip those if done.

## 1. Create directories

```bash
sudo install -d -o homelab -g homelab -m 755 /home/homelab/nextcloud
sudo install -d -o homelab -g homelab -m 755 /home/homelab/nextcloud/html
sudo install -d -o 999 -g 999 -m 700 /home/homelab/nextcloud/postgres
```

Postgres in the container runs as UID `999` — do **not** `chown` the `postgres/` dir to `homelab`.

## 2. Generate a database password

```bash
openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c 40
```

## 3. Create `.env`

```bash
sudoedit /home/homelab/nextcloud/.env
```

Use the public hostname **`drive.erdohat.com`** (no scheme):

```dotenv
POSTGRES_PASSWORD=PUT_PASSWORD_HERE
POSTGRES_DB=nextcloud
POSTGRES_USER=nextcloud
NEXTCLOUD_TRUSTED_DOMAINS=drive.erdohat.com
OVERWRITEHOST=drive.erdohat.com
OVERWRITEPROTOCOL=https
TZ=Europe/Budapest
```

## 4. Create compose file

```bash
sudoedit /home/homelab/nextcloud/docker-compose.yml
```

```yaml
name: nextcloud

services:
  db:
    image: postgres:16
    container_name: nextcloud_db
    restart: always
    volumes:
      - /home/homelab/nextcloud/postgres:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:alpine
    container_name: nextcloud_redis
    restart: always

  app:
    image: nextcloud:latest
    container_name: nextcloud_app
    restart: always
    ports:
      - "8081:80"
    volumes:
      - /home/homelab/nextcloud/html:/var/www/html
    environment:
      POSTGRES_HOST: db
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      REDIS_HOST: redis
      NEXTCLOUD_TRUSTED_DOMAINS: ${NEXTCLOUD_TRUSTED_DOMAINS}
      OVERWRITEHOST: ${OVERWRITEHOST}
      OVERWRITEPROTOCOL: ${OVERWRITEPROTOCOL}
      TRUSTED_PROXIES: 127.0.0.1
      TZ: ${TZ}
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    networks:
      default:
        aliases:
          - nextcloud.wopi.local

networks:
  default:
    name: nextcloud_default
```

Host port **8081** (not 8080). The `nextcloud.wopi.local` alias lets ONLYOFFICE reach Nextcloud over Docker DNS — see [onlyoffice.md](./onlyoffice.md).

## 5. Ownership

```bash
sudo chown homelab:homelab /home/homelab/nextcloud/.env /home/homelab/nextcloud/docker-compose.yml
sudo chmod 600 /home/homelab/nextcloud/.env
```

## 6. Start Nextcloud

```bash
sudo -u homelab docker compose -f /home/homelab/nextcloud/docker-compose.yml --env-file /home/homelab/nextcloud/.env up -d
```

## 7. Check status

```bash
sudo -u homelab docker compose -f /home/homelab/nextcloud/docker-compose.yml --env-file /home/homelab/nextcloud/.env ps
```

Local: `http://127.0.0.1:8081`  
Public: `https://drive.erdohat.com` — see [custom-domains.md](./custom-domains.md).

## 8. Finish in the browser

Create the admin account, then add users under **Users**.

If trusted-domain errors appear, confirm `.env` host matches the Funnel URL host:port and recreate:

```bash
sudo -u homelab docker compose -f /home/homelab/nextcloud/docker-compose.yml --env-file /home/homelab/nextcloud/.env up -d
```

## 9. Fix Postgres permission errors

If setup fails with `could not open file "global/pg_filenode.map": Permission denied`, the `postgres/` data dir has wrong ownership.

Fresh install (no data yet):

```bash
sudo -u homelab docker compose -f /home/homelab/nextcloud/docker-compose.yml --env-file /home/homelab/nextcloud/.env down
sudo rm -rf /home/homelab/nextcloud/postgres/*
sudo chown -R 999:999 /home/homelab/nextcloud/postgres
sudo chmod 700 /home/homelab/nextcloud/postgres
sudo -u homelab docker compose -f /home/homelab/nextcloud/docker-compose.yml --env-file /home/homelab/nextcloud/.env up -d
```

Then reload the setup page and create the admin account again.

## 10. Restart

```bash
sudo -u homelab docker compose -f /home/homelab/nextcloud/docker-compose.yml --env-file /home/homelab/nextcloud/.env restart
```

## 11. Office editing

In-browser Word/Excel/PowerPoint — see [onlyoffice.md](./onlyoffice.md). Uses existing Nextcloud users (no extra accounts).
