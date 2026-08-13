# OpenCode on the host

Native [OpenCode](https://opencode.ai/docs/) web UI on the development machine (full local toolchain). Homelab Docker is for media / cloud apps only — see [homelab/README.md](./homelab/README.md).

Official refs: [Web](https://opencode.ai/docs/web/), [Server](https://opencode.ai/docs/server/), [CLI](https://opencode.ai/docs/cli/).

## Why host

- Full Node / Go / local tools on the machine you develop on
- Projects are native home dirs (no container bind-mount path quirks)
- Cursor OAuth proxy stays on `127.0.0.1` — do not publish it

If the machine sleeps or is off, remote access stops.

## Access model

OpenCode is available through Caddy at `https://opencode.erdohat.com` with
HTTP Basic Auth. The direct Tailscale URL remains available as a fallback.

| Access               | How                                                   |
| -------------------- | ----------------------------------------------------- |
| On the machine       | `http://127.0.0.1:4096`                               |
| Phone / other device | Same Tailscale tailnet → `http://<tailscale-ip>:4096` |
| Public remote access | `https://opencode.erdohat.com` → Caddy → `:4096` |

`<tailscale-ip>` is this host’s Tailscale IPv4 (`tailscale ip -4`). HTTP basic auth required.

| What                     | Reachable how                                                                  |
| ------------------------ | ------------------------------------------------------------------------------ |
| OpenCode web             | Tailscale → `:4096`                                                            |
| App ↔ db on the host     | `localhost` (always)                                                           |
| Dev server UI from phone | Tailscale → `http://<tailscale-ip>:<dev-port>` if the app listens on `0.0.0.0` |

Do **not** use Tailscale Funnel for OpenCode or random dev ports. Do **not** expose Cursor proxy `65535`. Do not put OpenCode behind Cloudflare orange-cloud / free Tunnel. Keep strong Basic Auth enabled.

Do **not** run `tailscale serve` on HTTPS `:443` on a host that already Funnel’s Immich there — it steals that mapping. Prefer direct `:<port>` over the tailnet IP.

## Architecture

```text
Tailscale client (VPN)
    → http://<tailscale-ip>:4096
    → opencode web (0.0.0.0:4096)  [systemd --user]
    → cursor-oauth-opencode → 127.0.0.1:65535 → Cursor
    → local project trees on the host
```

## Setup

### 1. Config

```bash
cd /path/to/dots/stow && stow -t ~ opencode
cd /path/to/dots/stow && stow -t ~ systemd   # includes opencode-web.service
opencode auth login   # Cursor
```

### 2. Case-sensitive project paths (Linux)

OpenCode (especially the **web UI**) may store or request paths with a different directory case than the real folders (e.g. `~/projects` vs `~/Projects`). On Linux that breaks prompts with silent failures / `ENOENT`, while TUI / `opencode attach` can still look fine if they used the correct path.

If your real trees are capitalized, add stable symlinks once:

```bash
# adjust names to match your home layout
ln -sfn "$HOME/Projects" "$HOME/projects"
ln -sfn "$HOME/Work" "$HOME/work"
```

Prefer opening projects with the **canonical** casing in the UI. After fixing paths, start a **new** session (old sessions may still point at bad paths).

### 3. Manual test

```bash
opencode web --hostname 0.0.0.0 --port 4096
```

Open `http://127.0.0.1:4096` → pick a local project → run e.g. `node --version`.

### 4. Server basic auth (`server.env`)

Not in git (`server.env` is gitignored). Create:

```bash
umask 077
cat > ~/.config/opencode/server.env <<'ENV'
OPENCODE_SERVER_USERNAME=opencode
OPENCODE_SERVER_PASSWORD=PUT_PASSWORD_HERE
OPENCODE_PORT=4096
ENV
chmod 600 ~/.config/opencode/server.env
```

Generate a password:

```bash
openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c 40
```

### 5. systemd user service

Unit: `~/.config/systemd/user/opencode-web.service` (stow `systemd` package). Listens on **`0.0.0.0`** so Tailscale peers can reach `:4096`.

```bash
systemctl --user daemon-reload
systemctl --user enable --now opencode-web
sudo loginctl enable-linger $USER   # survives logout
```

Ensure Tailscale itself starts on boot:

```bash
sudo systemctl enable --now tailscaled
```

Check:

```bash
systemctl --user status opencode-web
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:4096/   # 401 = up
curl -s -o /dev/null -w '%{http_code}\n' -u 'opencode:PASSWORD' http://127.0.0.1:4096/
```

### 6. Cursor plugin patch (`crsr_…`)

Upstream `cursor-oauth-opencode` overwrites durable user API keys (`crsr_…`) with short-lived JWTs on refresh. Local patch keeps `crsr_` in `auth.json`:

```bash
~/.config/opencode/scripts/patch-cursor-oauth.sh
```

Re-run after `npm install` in `~/.config/opencode` or when OpenCode refreshes `cursor-oauth-opencode@latest` under `~/.cache/opencode/packages/`. Restart `opencode-web` after patching.

If `~/.local/share/opencode/auth.json` already lost `crsr_…` (both `access` and `refresh` are JWTs), set `refresh` back to the Cursor **user** API key, `expires` to `0`, empty `access`, then restart the service / run once.

### Cursor Code (sandbox) provider

`cursor-oauth-opencode` registers two providers: **Cursor** (`/v1`, native tools) and **Cursor Code** (`/v1/code`, sandbox). To keep only **Cursor** without patching the plugin, use OpenCode’s top-level config:

```json
"disabled_providers": ["cursor-code"]
```

The plugin may still merge `cursor-code` into config at runtime; OpenCode ignores disabled provider IDs in the model picker. Re-run `stow -t ~ opencode` from this repo — the stowed `opencode.json` includes that setting and omits the duplicate `provider.cursor-code` block.

### 7. Remote over Tailscale (VPN)

```bash
tailscale ip -4          # on the OpenCode host
# browser on another device: http://100.x.x.x:4096
```

HTTP basic auth = `OPENCODE_SERVER_*` from `server.env`.

Homelab public Caddy domains: [homelab/custom-domains.md](./homelab/custom-domains.md).

## Daily use

| Client             | How                                                                    |
| ------------------ | ---------------------------------------------------------------------- |
| Mobile / remote    | Tailscale VPN → `http://<tailscale-ip>:4096` → basic auth              |
| Desktop web        | `http://127.0.0.1:4096`                                                |
| Desktop TUI        | `opencode /path/to/project` or `opencode attach http://127.0.0.1:4096` |
| Dev app from phone | Tailscale → `http://<tailscale-ip>:<port>` (app must bind `0.0.0.0`)   |

```bash
export OPENCODE_SERVER_USERNAME=opencode
export OPENCODE_SERVER_PASSWORD='your-ui-password'
opencode attach http://127.0.0.1:4096
```

## Restart

```bash
systemctl --user restart opencode-web
```

## Security

- Strong `OPENCODE_SERVER_PASSWORD` (port is reachable on LAN + Tailscale interfaces).
- No public Funnel for OpenCode.
- Never commit `server.env`, `auth.json`, real hostnames, IPs, or passwords.
- Cursor proxy stays on `127.0.0.1:65535`.

## Troubleshooting

**`401` without `-u`**

- Expected — basic auth required.

**Service won’t start / port in use**

- Something else bound to `4096`: `ss -tlnp | grep 4096` (or `sudo lsof -i :4096`), stop that process, then `systemctl --user restart opencode-web`.

**Web UI shows no agent reply; TUI / attach works**

- Almost always a **path casing** problem on Linux (`ENOENT` in `~/.local/share/opencode/log/opencode.log`).
- Add the §2 symlinks, fix stored paths if needed, **new session**, hard-refresh the browser.
- Confirm log no longer shows `FileSystem.realPath (.../projects/...)` failures.

**Cursor auth expires / `Invalid User API Key`**

- Re-apply §6 patch; restore `crsr_…` in `auth.json` if refresh is already a JWT.

**Cursor / Node errors**

- Host needs `node` on `PATH` for `cursor-oauth-opencode`. Re-run `opencode auth login` if models missing after a clean auth (then restore `crsr_…` + patch).

**Built-in OpenCode models (`big-pickle`, etc.) say “No provider available”**

- Separate from Cursor. Needs OpenCode’s own provider auth; Cursor models are the intended path on this host.

**Remote unreachable**

- Client not on Tailscale; wrong IP; `tailscaled` / `opencode-web` down; machine asleep / off; or firewall blocking `:4096`.
