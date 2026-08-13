# Immich

Immich is deployed as a containerized service under a dedicated service
account. Keep its compose file, environment file, media storage, database
storage, public hostname, and internal listener in private operations notes.

Use the upstream deployment documentation for installation and upgrades.
Expose it only through the private-origin reverse proxy described in
[custom-domains.md](./custom-domains.md). Keep the application and database
data protected by appropriate filesystem permissions and backups.
