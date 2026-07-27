# OpenCode (plan)

Self-hosted [OpenCode](https://opencode.ai/docs/) web UI on the homelab: Docker, `.env`, Tailscale Funnel, **Cursor Code** via [`cursor-oauth-opencode`](https://www.npmjs.com/package/cursor-oauth-opencode).

**Status:** plan — Docker + Node image + user API key bootstrap documented; Funnel optional.

Official refs: [Web](https://opencode.ai/docs/web/), [Server](https://opencode.ai/docs/server/), image [`ghcr.io/anomalyco/opencode`](https://github.com/anomalyco/opencode/pkgs/container/opencode).

Use **`pkexec`** for root on the homelab host (create files, `docker exec`, Funnel). Run **`docker compose` as `homelab`** via `pkexec -u homelab`.

## Setup order

1. Directories → `.env` → **`Dockerfile`** (Node.js) → `docker-compose.yml`
2. `package.json` + `opencode.json` → `npm install` in `config/`
3. **Ownership** (`homelab` user; files from `pkexec` / editors are often `root`)
4. **`docker compose up -d --build`** (container name **`opencode`** must exist)
5. **Cursor auth** — `CURSOR_API_KEY` in `.env`, bootstrap → `data/auth.json` (§9)
6. Funnel `:10000` (optional)

## What this gives you

| Access | URL |
|--------|-----|
| Local | `http://127.0.0.1:4096` |
| Tailnet (no Funnel) | `http://100.x.x.x:4096` + HTTP basic auth |
| Public (Funnel) | `https://YOUR_FUNNEL_HOST:10000` + HTTP basic auth |

OpenCode runs tools/shell against mounted workspaces — treat this like **SSH with extra steps**. Use a strong `OPENCODE_SERVER_PASSWORD`. Prefer **tailnet-only** for daily use; enable Funnel only when you need the web UI from a browser without Tailscale.

Do **not** put OpenCode behind Cloudflare orange-cloud / free Tunnel.

## Ports

| Public Funnel | Local | Service |
|---------------|-------|---------|
| `:443` | `2283` | Immich |
| `:8443` | `8081` | Nextcloud |
| `:9443` | `9980` | ONLYOFFICE |
| `:10000` | `4096` | OpenCode web |

Inside the container, **`cursor-oauth-opencode`** binds **`127.0.0.1:65535`** (Cursor proxy). Do not publish that port on the host.

Host port `8080` stays reserved (gems Keycloak). OpenCode uses **4096**.

## Architecture

```text
Browser / Tailscale client
    → Funnel :10000 (optional) or tailnet :4096
    → opencode container (opencode web)
    → cursor-oauth-opencode → 127.0.0.1:65535 → Cursor subscription
    → workspaces: /home/homelab/opencode/workspaces
```

| Provider | Picker | Use |
|----------|--------|-----|
| **Cursor Code** | `cursor-code/<model>` | Cursor subscription via sandbox `code` tool |

Other OpenCode configs may also define **`cursor`** (`/v1`, native tools). This guide uses **`cursor-code` only** (`/v1/code`). Cursor credentials use provider id **`cursor`** in `auth.json` (not `cursor-code`).

## 1. Create directories

```bash
pkexec install -d -o homelab -g homelab -m 755 /home/homelab/opencode
pkexec install -d -o homelab -g homelab -m 755 /home/homelab/opencode/workspaces
pkexec install -d -o homelab -g homelab -m 755 /home/homelab/opencode/config
pkexec install -d -o homelab -g homelab -m 700 /home/homelab/opencode/data
```

## 2. Generate secrets

```bash
openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c 40
```

Use for `OPENCODE_SERVER_PASSWORD` in `.env`.

## 3. Create `.env`

```bash
pkexec nano /home/homelab/opencode/.env
```

```dotenv
OPENCODE_BASE_IMAGE=ghcr.io/anomalyco/opencode:latest
OPENCODE_PORT=4096
OPENCODE_SERVER_USERNAME=opencode
OPENCODE_SERVER_PASSWORD=PUT_PASSWORD_HERE
# User API key from https://cursor.com/dashboard/api (same as Cursor CLI CURSOR_API_KEY)
CURSOR_API_KEY=PUT_CURSOR_USER_API_KEY_HERE
TZ=Europe/Budapest
```

`CURSOR_API_KEY` is **not** read by OpenCode or the plugin directly. Bootstrap §9 once to write `data/auth.json`. Keep `.env` mode `600`.

## 4. `Dockerfile` (Node.js for Cursor plugin)

[`cursor-oauth-opencode`](https://www.npmjs.com/package/cursor-oauth-opencode) spawns **`node`** for its HTTP/2 bridge (`h2-daemon.mjs`). The upstream `ghcr.io/anomalyco/opencode` image ships **only** the `opencode` binary — no `node` on `PATH`. Without Node you get **`executable not found on path: node`** and Cursor fails (web UI may show **`Cursor proxy context is stale or unknown`** after a bad partial start).

```bash
pkexec nano /home/homelab/opencode/Dockerfile
```

```dockerfile
ARG OPENCODE_BASE_IMAGE=ghcr.io/anomalyco/opencode:latest
FROM ${OPENCODE_BASE_IMAGE}
USER root
RUN apk add --no-cache nodejs
```

Pin `OPENCODE_BASE_IMAGE` in `.env` when you upgrade OpenCode (e.g. `ghcr.io/anomalyco/opencode:1.18.7`).

## 5. Create `docker-compose.yml`

```bash
pkexec nano /home/homelab/opencode/docker-compose.yml
```

```yaml
name: opencode

services:
  opencode:
    build:
      context: /home/homelab/opencode
      dockerfile: Dockerfile
      args:
        OPENCODE_BASE_IMAGE: ${OPENCODE_BASE_IMAGE}
    image: opencode-homelab:local
    container_name: opencode
    restart: always
    ports:
      - "${OPENCODE_PORT}:4096"
    environment:
      OPENCODE_SERVER_USERNAME: ${OPENCODE_SERVER_USERNAME}
      OPENCODE_SERVER_PASSWORD: ${OPENCODE_SERVER_PASSWORD}
      TZ: ${TZ}
    volumes:
      - /home/homelab/opencode/workspaces:/workspaces
      - /home/homelab/opencode/config:/root/.config/opencode
      - /home/homelab/opencode/data:/root/.local/share/opencode
    working_dir: /workspaces
    command:
      - web
      - --hostname
      - "0.0.0.0"
      - --port
      - "4096"
```

After changing `Dockerfile` or `OPENCODE_BASE_IMAGE`, rebuild:

```bash
pkexec -u homelab docker compose -f /home/homelab/opencode/docker-compose.yml --env-file /home/homelab/opencode/.env build --no-cache
```

## 6. Cursor config (`package.json` + `opencode.json`)

```bash
pkexec nano /home/homelab/opencode/config/package.json
```

```json
{
  "dependencies": {
    "@ai-sdk/openai-compatible": "^3.0.11",
    "@opencode-ai/plugin": "1.17.9",
    "cursor-oauth-opencode": "^0.9.18"
  }
}
```

```bash
pkexec nano /home/homelab/opencode/config/opencode.json
```

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": [
    "cursor-oauth-opencode@latest"
  ],
  "provider": {
    "cursor-code": {
      "name": "Cursor Code",
      "npm": "@ai-sdk/openai-compatible",
      "api": "http://127.0.0.1:65535/v1/code"
    }
  }
}
```

After §9, the plugin discovers models from Cursor (no `models` block in this file).

Install plugin dependencies (**before** first `compose up`):

```bash
pkexec docker run --rm -u root \
  -v /home/homelab/opencode/config:/root/.config/opencode \
  -w /root/.config/opencode \
  node:22-bookworm-slim \
  npm install
```

## 7. Ownership

`pkexec` and the `npm install` container leave some paths as **root**. Fix before `docker compose`:

```bash
pkexec chown homelab:homelab /home/homelab/opencode/.env /home/homelab/opencode/docker-compose.yml /home/homelab/opencode/Dockerfile
pkexec chown -R homelab:homelab /home/homelab/opencode/config
pkexec chown -R homelab:homelab /home/homelab/opencode/data /home/homelab/opencode/workspaces
pkexec chmod 600 /home/homelab/opencode/.env
```

## 8. Start OpenCode

```bash
pkexec -u homelab docker compose -f /home/homelab/opencode/docker-compose.yml --env-file /home/homelab/opencode/.env up -d --build
pkexec -u homelab docker compose -f /home/homelab/opencode/docker-compose.yml --env-file /home/homelab/opencode/.env ps
```

Confirm Node is on `PATH` inside the container:

```bash
pkexec docker exec opencode sh -c 'command -v node && node -v'
```

Expect container name **`opencode`**, port **`0.0.0.0:4096->4096`**.

Health (no credentials → **`401`** is OK — server is up):

```bash
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:4096/
```

With basic auth (use values from `.env`):

```bash
curl -s -o /dev/null -w '%{http_code}\n' -u 'opencode:PUT_PASSWORD_HERE' http://127.0.0.1:4096/
```

## 9. Cursor user API key → `auth.json`

Bootstrap only needs the `data/` directory to exist; restart the container (§8) before testing the UI.

### User API key vs team Admin API key

| Key | Where | Works with OpenCode + `cursor-oauth-opencode`? |
|-----|--------|-----------------------------------------------|
| **User API key** | [Dashboard → API Keys](https://cursor.com/dashboard/api) | **Yes** (via `auth.json`, below) |
| **Team Admin API key** | Team settings / `api.cursor.com` billing APIs | **No** — admin/billing only |

The plugin does **not** load `CURSOR_API_KEY` from the container environment (unlike [Cursor CLI](https://cursor.com/docs/cli/reference/authentication)). Store the key in **`.env`**, then write **`/home/homelab/opencode/data/auth.json`** once. Do **not** use `opencode auth login` or browser OAuth on the server.

After `CURSOR_API_KEY` is in `.env`:

```bash
set -a
source /home/homelab/opencode/.env
set +a
test -n "$CURSOR_API_KEY"

pkexec install -o homelab -g homelab -m 600 /dev/null /home/homelab/opencode/data/auth.json
jq -n --arg refresh "$CURSOR_API_KEY" \
  '{cursor: {type: "oauth", access: "", refresh: $refresh, expires: 0}}' \
  | pkexec tee /home/homelab/opencode/data/auth.json > /dev/null
pkexec chown homelab:homelab /home/homelab/opencode/data/auth.json
pkexec chmod 600 /home/homelab/opencode/data/auth.json

pkexec -u homelab docker compose -f /home/homelab/opencode/docker-compose.yml --env-file /home/homelab/opencode/.env restart opencode
```

On first model use, the plugin exchanges the key at `https://api2.cursor.sh/auth/exchange_user_api_key` and stores short-lived JWTs in `auth.json`. The user API key can remain in `refresh` if Cursor does not rotate it away.

Optional check from the host (should **not** be `401 Invalid User API Key`):

```bash
set -a && source /home/homelab/opencode/.env && set +a
curl -sS -X POST https://api2.cursor.sh/auth/exchange_user_api_key \
  -H "Authorization: Bearer $CURSOR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{}' | jq -r 'if .accessToken then "ok" else . end'
```

## 10. Funnel

After the container is healthy — [funnel.md](./funnel.md):

```bash
pkexec tailscale funnel --bg --https=10000 4096
```

Public: `https://YOUR_FUNNEL_HOST:10000` (basic auth, then OpenCode UI).

## 11. Verify

1. `docker ps` shows **`opencode`** running.
2. Browser: basic auth (`OPENCODE_SERVER_*`), then web UI.
3. Models: **Cursor Code** (`cursor-code/…`); pick e.g. `cursor-code/composer-2.5-fast`.
4. Test prompt under `/workspaces`.
5. After container rebuild/restart: **hard refresh** the browser (or open a **new** session) so stale Cursor proxy context IDs are cleared.

## 12. Remote clients (CLI / TUI)

The container runs **`opencode web`** — an HTTP API plus browser UI. Your machine runs a **client** that talks to that URL. Cursor auth stays on the server (`CURSOR_API_KEY` / `auth.json`); the client only needs **HTTP basic auth** (`OPENCODE_SERVER_*`).

| Access | Base URL |
|--------|----------|
| Tailnet | `http://100.x.x.x:4096` |
| Tailscale Funnel | `https://YOUR_FUNNEL_HOST:10000` |

Replace with your host’s tailnet IP or Funnel hostname from `tailscale status` / `tailscale funnel status`.

### Browser

Open the base URL in a browser. Enter `OPENCODE_SERVER_USERNAME` / `OPENCODE_SERVER_PASSWORD` when prompted.

### TUI (attach to remote server)

Install [OpenCode](https://opencode.ai/docs/) on your machine (same major version as the image when possible). Point the TUI at the server:

```bash
export OPENCODE_SERVER_USERNAME=opencode
export OPENCODE_SERVER_PASSWORD='your-ui-password'

# Tailnet example
opencode attach http://100.x.x.x:4096

# Funnel example (HTTPS)
opencode attach https://YOUR_FUNNEL_HOST:10000
```

Or pass credentials on the command line:

```bash
opencode attach -u opencode -p 'your-ui-password' http://100.x.x.x:4096
```

**Workspace:** tools and shell run on the server under **`/workspaces`**, not your local tree. Use `--dir` only for a path that exists **inside** the container.

### CLI (non-interactive)

```bash
export OPENCODE_SERVER_USERNAME=opencode
export OPENCODE_SERVER_PASSWORD='your-ui-password'

opencode run --attach http://100.x.x.x:4096 \
  -m cursor-code/composer-2.5-fast \
  "Summarize what is in /workspaces"
```

### Health / API

```bash
curl -s -u 'opencode:your-ui-password' http://100.x.x.x:4096/global/health
```

Official refs: [CLI `attach` / `run`](https://opencode.ai/docs/cli/), [Web](https://opencode.ai/docs/web/), [Server](https://opencode.ai/docs/server/).

## 13. Restart

```bash
pkexec -u homelab docker compose -f /home/homelab/opencode/docker-compose.yml --env-file /home/homelab/opencode/.env restart
```

## Boot / login

Same as [README.md](./README.md): `docker.service` + `tailscaled`; container `restart: always`.

## Security notes

- Funnel exposes a Cursor-backed agent — strong basic auth; prefer tailnet-only.
- Optional: add `"share": "disabled"` to `opencode.json`.
- Never commit `auth.json`, `.env` (includes `CURSOR_API_KEY`), or Funnel hostnames.

## Troubleshooting

**`No such container: opencode`**

- Run §8 (`compose up -d --build`).

**`executable not found on path: node`**

- Build the §4 image (`opencode-homelab:local`); verify §8 `docker exec … node -v`.

**`Cursor proxy context is stale or unknown; reload the OpenCode workspace`**

- Usually missing Node and/or container restart while the browser kept an old proxy context. Fix Node, `compose up -d --build`, then hard-refresh the web UI or start a new session.

**`401` from `curl` without `-u`**

- Expected — web server requires basic auth.

**`compose` permission errors**

- Run §7 (`chown` to `homelab`); compose must run as **`pkexec -u homelab`**, not root.

**Cursor models missing**

- Re-run §9 after rotating the user API key; confirm the exchange `curl` returns `ok`.
- Plugin log: `pkexec docker exec opencode cat /root/.cache/cursor-oauth-opencode/plugin.log`

**Proxy errors**

- `api` on `cursor-code` must stay `http://127.0.0.1:65535/v1/code`.

**Funnel 502**

- `curl http://127.0.0.1:4096` on the host must work first; check `tailscale funnel status` for `:10000` → `4096`.

## Later

- Pin `OPENCODE_BASE_IMAGE` to a tag (e.g. `1.18.7`) in `.env`, then `build --no-cache`.
- [future-domains.md](./future-domains.md) for pretty hostnames.
