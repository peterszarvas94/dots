# Homelab

Services run as the `homelab` user (Docker). Public access: **Tailscale Funnel** on one hostname, multiple HTTPS ports. No pretty domain for now.

OpenCode is on the development host (Tailscale VPN / Serve, not Funnel) — [../opencode-host.md](../opencode-host.md).

Get your Funnel hostname with:

```bash
tailscale status
tailscale funnel status
```

## URLs

| Service    | Public URL                      | Local port |
|------------|---------------------------------|------------|
| Immich     | `https://YOUR_FUNNEL_HOST`      | 2283       |
| Nextcloud  | `https://YOUR_FUNNEL_HOST:8443` | 8081       |
| ONLYOFFICE | `https://YOUR_FUNNEL_HOST:9443` | 9980       |

ONLYOFFICE Document Server is used for in-browser editing; you normally don’t open `:9443` directly.

OpenCode is not Funnel’d — [../opencode-host.md](../opencode-host.md).

## Setup order

1. [immich.md](./immich.md)
2. [nextcloud.md](./nextcloud.md)
3. [funnel.md](./funnel.md) — Immich + Nextcloud (+ document server on `:9443`)
4. [onlyoffice.md](./onlyoffice.md) — Office editing

## Boot / login

No desktop login needed. After reboot:

- `docker.service` and `tailscaled` start as system services
- Immich / Nextcloud / ONLYOFFICE containers use `restart: always`
- Funnel `--bg` config is stored in `tailscaled`

Check:

```bash
docker ps
tailscale funnel status
```

## Restart

```bash
sudo -u homelab docker compose -f /home/homelab/immich/docker-compose.yml --env-file /home/homelab/immich/.env restart

sudo -u homelab docker compose -f /home/homelab/nextcloud/docker-compose.yml --env-file /home/homelab/nextcloud/.env restart

sudo -u homelab docker compose -f /home/homelab/onlyoffice/docker-compose.yml --env-file /home/homelab/onlyoffice/.env restart
```

## Later

- Pretty names on your own domain: front-door VPS on Tailscale — see [future-domains.md](./future-domains.md).

## Rules

- Host port `8080` may be taken by other stacks — Nextcloud uses `8081`.
- Do not put Immich behind Cloudflare orange-cloud / free Tunnel (~100 MB upload limit).
- Funnel HTTPS cert covers the MagicDNS hostname on all Funnel ports.
- Do not commit real Funnel hostnames, domains, or passwords to this repo — use placeholders.
