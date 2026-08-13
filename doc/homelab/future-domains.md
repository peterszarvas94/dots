# Custom domains

The custom-domain setup is now documented in [custom-domains.md](./custom-domains.md).
The active Nextcloud hostname is `drive.erdohat.com`.

## Architecture

```text
Internet → `hal` (public IP, Caddy + automatic HTTPS)
               ↓ Tailscale only (private)
          Asimov
           Immich    :2283
           Nextcloud :8081
           ONLYOFFICE :9980
```

- `hal` is public.
- `hal` is already joined to the same **Tailscale** network as Asimov.
- Caddy on `hal` reverse-proxies **only chosen host:ports**.
- DNS `A` → VPS IP (Cloudflare **DNS only** / grey cloud — not proxied).
- Existing Funnel URLs remain rollback paths until all custom domains are tested.

## Steps (later)

1. Add DNS-only records for `photos`, `drive`, `office`, and `notes` to `hal`.
2. Configure Caddy on `hal`; it obtains and renews certificates automatically.
3. Update Nextcloud and ONLYOFFICE public URLs; keep Docker-internal URLs.
4. Bind ZenNotes to Asimov's Tailscale address so `hal` can reach it.
5. Remove Funnel only after external verification.

Avoid Cloudflare orange-cloud / free Tunnel for Immich (~100 MB upload limit).
