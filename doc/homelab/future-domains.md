# Future Public Services

When adding a public service, use a dedicated subdomain and route it through
the existing authenticated reverse-proxy pattern. Keep the service host,
private address, listener, deployment path, and provider configuration in
private operational documentation.

Before publishing a service:

- Confirm that only the proxy is reachable from the internet.
- Configure the application’s canonical HTTPS URL and trusted proxy settings.
- Keep authentication, encryption, and signing protections enabled.
- Verify the service externally without documenting live infrastructure here.
