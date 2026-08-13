# Immich

Google Photos alternative. Owned by `homelab`.

## 0. Remove the partial `immich` user (if present)

```bash
sudo userdel -r immich
```

## 1. Create the `homelab` user

```bash
sudo useradd -m -s /bin/bash -G docker homelab
```

If it already exists:

```bash
sudo usermod -aG docker homelab
```

## 2. Enable and start Docker

```bash
sudo systemctl enable docker.service
sudo systemctl start docker.service
```

## 3. Install and start Tailscale

```bash
sudo pacman -S --needed tailscale
sudo systemctl enable --now tailscaled.service
sudo tailscale up
```

Public HTTPS is `https://photos.erdohat.com` through Caddy on `hal` — see [custom-domains.md](./custom-domains.md).

## 4. Create Immich directories

```bash
sudo install -d -o homelab -g homelab -m 755 /home/homelab/immich
sudo install -d -o homelab -g homelab -m 755 /home/homelab/immich/library
sudo install -d -o homelab -g homelab -m 700 /home/homelab/immich/postgres
```

## 5. Download the compose file

```bash
sudo curl -fsSL -o /home/homelab/immich/docker-compose.yml https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
```

## 6. Generate a database password

```bash
openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c 40
```

## 7. Create `.env`

```bash
sudoedit /home/homelab/immich/.env
```

```dotenv
UPLOAD_LOCATION=/home/homelab/immich/library
DB_DATA_LOCATION=/home/homelab/immich/postgres
TZ=Europe/Budapest
IMMICH_VERSION=v3
DB_PASSWORD=PUT_PASSWORD_HERE
DB_USERNAME=postgres
DB_DATABASE_NAME=immich
```

## 8. Ownership

```bash
sudo chown homelab:homelab /home/homelab/immich/.env /home/homelab/immich/docker-compose.yml
sudo chmod 600 /home/homelab/immich/.env
```

## 9. Start Immich

```bash
sudo -u homelab docker compose -f /home/homelab/immich/docker-compose.yml --env-file /home/homelab/immich/.env up -d
```

## 10. Check status

```bash
sudo -u homelab docker compose -f /home/homelab/immich/docker-compose.yml --env-file /home/homelab/immich/.env ps
```

Local: `http://127.0.0.1:2283`  
Public: `https://photos.erdohat.com`

## 11. Restart

```bash
sudo -u homelab docker compose -f /home/homelab/immich/docker-compose.yml --env-file /home/homelab/immich/.env restart
```

Expose publicly with [funnel.md](./funnel.md) (`sudo tailscale funnel --bg 2283`).

## 12. Second account

Administration → Users → Create user.

## CLI upload

```bash
npm i -g @immich/cli
immich login https://YOUR_FUNNEL_HOST YOUR_API_KEY
immich upload -r /path/to/photos
```
