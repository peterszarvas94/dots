# Legacy Tailscale Funnel And Serve

This document describes the previous direct-Funnel setup. The active public
setup uses Caddy on `hal` with `erdohat.com` subdomains; see
[custom-domains.md](./custom-domains.md). Keep these mappings only as rollback
or emergency access paths.

Public Funnel routes and private tailnet-only Serve routes. Tailscale handles
TLS for both. ONLYOFFICE is public because browsers outside the tailnet need
its editor assets while editing Nextcloud documents; JWT protects document
requests.

Homelab apps only. OpenCode is **not** Funnel’d — Tailscale VPN + Serve on the host: [../opencode-host.md](../opencode-host.md).

| Funnel HTTPS     | Local origin            | App        |
|------------------|-------------------------|------------|
| `:443` (default) | `http://127.0.0.1:2283` | Immich     |
| `:8443`          | `http://127.0.0.1:8081` | Nextcloud  |
| `:10000`         | `http://127.0.0.1:9980` | ONLYOFFICE |
| `:443 /zennotes` | `http://127.0.0.1:8090` | ZenNotes   |

Tailscale **public** Funnel allows HTTPS ports **`443`**, **`8443`**, and
**`10000`**. Do not use `:9443`: it may appear in Tailscale configuration but
is not a public Funnel port. Keep `:10000` dedicated to ONLYOFFICE.

## 0. Reset (optional)

```bash
sudo tailscale funnel reset
```

## 1. Immich (443 → 2283)

```bash
sudo tailscale funnel --bg 2283
```

## 2. Nextcloud (8443 → 8081)

```bash
sudo tailscale funnel --bg --https=8443 8081
```

## 3. Document server, public Funnel (10000 → 9980)

After ONLYOFFICE is running — see [onlyoffice.md](./onlyoffice.md):

```bash
sudo tailscale serve reset
sudo tailscale funnel --bg --https=10000 9980
```

The `serve reset` command removes tailnet-only Serve mappings. It does not
remove the public Funnel mappings.

## 4. ZenNotes (`/zennotes` → 8090)

After ZenNotes is running — see [zennotes.md](./zennotes.md):

```bash
sudo tailscale funnel --bg --https=443 --set-path=/zennotes 8090
```

## 5. Check

```bash
tailscale funnel status
```

Expected shape:

```text
https://YOUR_FUNNEL_HOST (Funnel on)
|-- / proxy http://127.0.0.1:2283

https://YOUR_FUNNEL_HOST:8443 (Funnel on)
|-- / proxy http://127.0.0.1:8081

https://YOUR_FUNNEL_HOST:10000 (Funnel on)
|-- / proxy http://127.0.0.1:9980

https://YOUR_FUNNEL_HOST (Funnel on)
|-- /zennotes proxy http://127.0.0.1:8090
```

- Immich: `https://YOUR_FUNNEL_HOST`
- Nextcloud: `https://YOUR_FUNNEL_HOST:8443`
- Document server (ONLYOFFICE): public `:10000` for browser-side Nextcloud editing; JWT remains enabled
- ZenNotes: `https://YOUR_FUNNEL_HOST/zennotes/`

## 6. Persist

`--bg` stores Funnel and Serve config in `tailscaled` (enabled on boot). After reboot:

```bash
tailscale funnel status
```

## Remove all Funnel mappings

```bash
sudo tailscale funnel reset
```
