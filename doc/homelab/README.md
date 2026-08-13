# Homelab

Services run as the `homelab` user (Docker). Public access uses Caddy on
`hal`, with Cloudflare DNS-only records and a private Tailscale hop to Asimov.
See [custom-domains.md](./custom-domains.md).

OpenCode is on the development host (Tailscale VPN / Serve, not Funnel) — [../opencode-host.md](../opencode-host.md).

The public application URLs are:

| Service    | Public URL                       | Local port |
|------------|----------------------------------|------------|
| Immich     | `https://photos.erdohat.com`     | 2283       |
| Nextcloud  | `https://drive.erdohat.com`     | 8081       |
| ONLYOFFICE | `https://office.erdohat.com`    | 9980       |
| ZenNotes   | `https://notes.erdohat.com`      | 8090       |

ONLYOFFICE is primarily a Nextcloud integration. Its public URL is needed when
users access Nextcloud outside the tailnet because their browsers load the
document editor assets from the Document Server. The endpoint has JWT enabled;
the public welcome page does not grant anonymous access to Nextcloud files.
Nextcloud uses `http://onlyoffice/` for internal server-to-server requests.

OpenCode is not public — [../opencode-host.md](../opencode-host.md).

## Setup order

1. [immich.md](./immich.md)
2. [nextcloud.md](./nextcloud.md)
3. [custom-domains.md](./custom-domains.md) — public Caddy on `hal`
4. [onlyoffice.md](./onlyoffice.md) — Office editing
5. [zennotes.md](./zennotes.md) — ZenNotes deployment

## Boot / login

No desktop login needed. After reboot:

- `docker.service` and `tailscaled` start as system services
- Immich / Nextcloud / ONLYOFFICE containers use `restart: always`
- Caddy and Tailscale start as system services on `hal`; Nginx is inactive.

Check:

```bash
docker ps
ssh peti@hal
sudo caddy validate --config /etc/caddy/Caddyfile
sudo systemctl status caddy
```

## Restart

```bash
sudo -u homelab docker compose -f /home/homelab/immich/docker-compose.yml --env-file /home/homelab/immich/.env restart

sudo -u homelab docker compose -f /home/homelab/nextcloud/docker-compose.yml --env-file /home/homelab/nextcloud/.env restart

sudo -u homelab docker compose -f /home/homelab/onlyoffice/docker-compose.yml --env-file /home/homelab/onlyoffice/.env restart
```

## Later

- Legacy Funnel setup: [funnel.md](./funnel.md).

## Rules

- Host port `8080` may be taken by other stacks — Nextcloud uses `8081`.
- `hal` is the public Caddy front door; Asimov service ports are tailnet origins.
- Cloudflare records must stay DNS-only; do not use Cloudflare Tunnel.
- ONLYOFFICE remains JWT-protected even though its editor assets are public.
- Do not commit real Funnel hostnames, domains, or passwords to this repo — use placeholders.
