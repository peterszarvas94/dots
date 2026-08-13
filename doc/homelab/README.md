# Homelab

Services run in containers under a dedicated service account. Public access
uses a reverse proxy and DNS-only records; application hosts remain private.
See [custom-domains.md](./custom-domains.md) for the generic pattern.

The public service catalog is intentionally kept outside this repository. Store
live URLs, machine names, network addresses, ports, paths, and credentials in
private operational documentation.

## Setup order

1. [immich.md](./immich.md)
2. [nextcloud.md](./nextcloud.md)
3. [custom-domains.md](./custom-domains.md)
4. [onlyoffice.md](./onlyoffice.md)
5. [zennotes.md](./zennotes.md)

## Rules

- Keep application origins private and expose only the reverse proxy.
- Do not use public tunnels for normal access.
- Do not commit real hostnames, IP addresses, ports, paths, or passwords.
- Keep authentication, encryption, and signing protections enabled.
