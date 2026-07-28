# OpenCode (homelab Docker — deprecated)

> **Deprecated.** OpenCode runs on the development host with Tailscale VPN (Serve), not Funnel and not Docker. See [../opencode-host.md](../opencode-host.md).

This file previously documented a Docker Compose deploy under the homelab user (Node image, Cursor plugin, workspace mounts, optional Funnel `:10000`). Do not follow it for new setups.

To tear down an old container:

```bash
docker compose down   # in the old opencode compose directory
```

If Funnel still maps `:10000` → `4096`, remove it (`tailscale funnel --https=10000 off`). Homelab Funnel for Immich / Nextcloud / ONLYOFFICE: [funnel.md](./funnel.md).
