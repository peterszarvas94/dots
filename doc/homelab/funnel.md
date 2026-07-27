# Tailscale Funnel

One Funnel host, multiple HTTPS ports. Tailscale handles TLS.

| Funnel HTTPS     | Local origin            | App        |
|------------------|-------------------------|------------|
| `:443` (default) | `http://127.0.0.1:2283` | Immich     |
| `:8443`          | `http://127.0.0.1:8081` | Nextcloud  |
| `:9443`          | `http://127.0.0.1:9980` | ONLYOFFICE |
| `:10000`         | `http://127.0.0.1:4096` | OpenCode   |

Tailscale **public** Funnel only allows HTTPS ports **`443`**, **`8443`**, and **`10000`**. Other ports (e.g. `:9443`, `:10443`) may listen on the tailnet only and work when Tailscale is connected, not from the open internet.

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

## 3. Document server (9443 → 9980)

After ONLYOFFICE is running — see [onlyoffice.md](./onlyoffice.md):

```bash
sudo tailscale funnel --bg --https=9443 9980
```

## 4. OpenCode (10000 → 4096)

When deployed — see [opencode.md](./opencode.md):

```bash
pkexec tailscale funnel --bg --https=10000 4096
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

https://YOUR_FUNNEL_HOST:9443 (Funnel on)
|-- / proxy http://127.0.0.1:9980

https://YOUR_FUNNEL_HOST:10000 (Funnel on)
|-- / proxy http://127.0.0.1:4096
```

- Immich: `https://YOUR_FUNNEL_HOST`
- Nextcloud: `https://YOUR_FUNNEL_HOST:8443`
- Document server (ONLYOFFICE): tailnet `:9443` only unless you use a public allowlist port
- OpenCode: `https://YOUR_FUNNEL_HOST:10000`

## 6. Persist

`--bg` stores config in `tailscaled` (enabled on boot). After reboot:

```bash
tailscale funnel status
```

## Remove all Funnel mappings

```bash
sudo tailscale funnel reset
```
