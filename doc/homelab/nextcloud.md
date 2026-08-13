# Nextcloud

Nextcloud is deployed as a containerized service under a dedicated service
account. Keep compose files, environment files, data paths, database details,
public hostname, and internal listener in private operations notes.

Configure the public HTTPS hostname as the canonical URL, add it to trusted
domains, and configure the reverse proxy as a trusted proxy. Keep internal
service-to-service addresses private and separate from the browser-facing URL.

Use the upstream deployment documentation for installation, upgrades, backups,
and recovery. Never place credentials or database data in this repository.
