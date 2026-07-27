# Future: pretty domains

Skip for now. Goal: `photos.YOUR_DOMAIN` / `cloud.YOUR_DOMAIN` (and Office) without Funnel ports in the URL.

## Architecture

```text
Internet → VPS (public IP, Caddy + Let's Encrypt)
              ↓ Tailscale only (private)
         home server
           Immich    :2283
           Nextcloud :8081
           ONLYOFFICE :9980
```

- Front-door **VPS** is public.
- VPS joins the same **Tailscale** network as this machine.
- Caddy on the VPS reverse-proxies **only chosen host:ports** (not the whole server).
- DNS `A` → VPS IP (Cloudflare **DNS only** / grey cloud — not proxied).
- Funnel can be turned off for those apps once the VPS is live.

## Steps (later)

1. Small VPS + Tailscale.
2. DNS: `photos` / `cloud` (and maybe `office`) → VPS.
3. Caddy: certs + `reverse_proxy` to `http://YOUR_TAILSCALE_HOSTNAME:2283`, `:8081`, `:9980`.
4. Update Nextcloud/ONLYOFFICE public URLs; keep Docker-internal URLs if still needed.
5. Optionally `sudo tailscale funnel reset`.

Avoid Cloudflare orange-cloud / free Tunnel for Immich (~100 MB upload limit).
