# ZenNotes

ZenNotes runs as the `homelab` user, using the system Docker daemon, like
Immich and Nextcloud. The application is kept in its own Compose project:

```text
/home/homelab/zennotes/
├── docker-compose.yml
├── .env
├── data/
└── vault/
```

The local host port is `8090`. Public access uses the dedicated hostname
`https://notes.erdohat.com` through Caddy on `hal` — see
[custom-domains.md](./custom-domains.md).

## 1. Create the directories

```bash
sudo install -d -o homelab -g homelab -m 755 /home/homelab/zennotes
sudo install -d -o homelab -g homelab -m 755 /home/homelab/zennotes/data
sudo install -d -o homelab -g homelab -m 700 /home/homelab/zennotes/vault
sudo chown -R homelab:homelab /home/homelab/zennotes/data /home/homelab/zennotes/vault
sudo chmod 700 /home/homelab/zennotes/vault
```

## 2. Create the Compose project

This follows the official [ZenNotes Docker guide](https://github.com/ZenNotes/zennotes/blob/main/docs/how-to/self-host-with-docker.md).
The host `homelab` user owns both mounted directories, and the container runs
with the same UID/GID so it can write the vault and application data.

```bash
sudoedit /home/homelab/zennotes/docker-compose.yml
```

```yaml
services:
  zennotes:
    image: adibhanna/zennotes
    user: "${ZENNOTES_UID}:${ZENNOTES_GID}"
    ports:
      - "127.0.0.1:8090:7878"
    volumes:
      - /home/homelab/zennotes/vault:/workspace
      - /home/homelab/zennotes/data:/data
    environment:
      ZENNOTES_AUTH_TOKEN: "${ZENNOTES_AUTH_TOKEN}"
      ZENNOTES_BEHIND_TLS: "1"
      ZENNOTES_PERSIST_SESSIONS: "1"
    restart: always
```

Create the Compose environment file with the `homelab` UID/GID and a random
bootstrap token:

```bash
sudoedit /home/homelab/zennotes/.env

id -u homelab
id -g homelab
openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c 40
```

Put the command results into `.env`:

```dotenv
ZENNOTES_UID=HOMELAB_UID
ZENNOTES_GID=HOMELAB_GID
ZENNOTES_AUTH_TOKEN=GENERATED_TOKEN
```

Keep `.env` private:

```bash
sudo chown homelab:homelab /home/homelab/zennotes/docker-compose.yml /home/homelab/zennotes/.env
sudo chmod 600 /home/homelab/zennotes/.env
```

## 3. Start ZenNotes

```bash
sudo -u homelab docker compose \
  -f /home/homelab/zennotes/docker-compose.yml \
  --env-file /home/homelab/zennotes/.env up -d
```

Check the service and local endpoint:

```bash
sudo -u homelab docker compose \
  -f /home/homelab/zennotes/docker-compose.yml \
  --env-file /home/homelab/zennotes/.env ps

curl -I http://127.0.0.1:8090
```

## 4. Expose ZenNotes through Funnel

After the local endpoint works, configure the dedicated `notes.erdohat.com`
Caddy route on `hal` using [custom-domains.md](./custom-domains.md).

Public URL:

```text
https://notes.erdohat.com
```

## 5. Restart

```bash
sudo -u homelab docker compose \
  -f /home/homelab/zennotes/docker-compose.yml \
  --env-file /home/homelab/zennotes/.env restart
```

The container uses `restart: always`, and the Funnel mapping created with
`--bg` is stored by `tailscaled`, so neither requires a desktop login after a
reboot.

## 6. Remove ZenNotes

Stop and remove the containers without deleting persistent data:

```bash
sudo -u homelab docker compose \
  -f /home/homelab/zennotes/docker-compose.yml \
  --env-file /home/homelab/zennotes/.env down
```

## Official reference

- [Self-host with Docker](https://github.com/ZenNotes/zennotes/blob/main/docs/how-to/self-host-with-docker.md)
- [Secure self-hosting](https://github.com/ZenNotes/zennotes/blob/main/docs/how-to/secure-self-hosting.md)
