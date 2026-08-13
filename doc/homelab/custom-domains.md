# Generic Public Reverse Proxy

Public application access can be provided by a reverse proxy. DNS records
should point to the proxy, while proxy-to-application traffic should use a
private network. Do not publish application hosts or internal listeners.

## DNS

Create DNS-only records for each public service:

```text
<SERVICE_SUBDOMAIN>  A  <PROXY_PUBLIC_IPV4>
```

Use `AAAA` records only after IPv6 has been configured and tested. Keep proxy
configuration, certificates, credentials, and provider-specific values on the
target machine, not in this repository.

## Reverse proxy

Configure one virtual host per service and route it to a private origin:

```text
<SERVICE_HOSTNAME> {
    reverse_proxy http://<PRIVATE_ORIGIN>
}
```

Enable HTTPS, validate the configuration, and reload the proxy using the
platform's normal service-management commands. Keep the application origin
unreachable from the public internet.

## Application settings

Set each application’s canonical URL to its public HTTPS hostname. Configure
trusted hosts and trusted proxies according to the application documentation.
Keep internal service-to-service URLs unchanged where applicable, and keep all
application authentication and signing keys enabled.

## Verification

Test each public hostname from outside the private network. Verify login,
uploads, editor integrations, callbacks, and any API clients. Do not use or
re-enable direct public tunnels for these services.
