# Custom Domains Through `hal`

Public homelab access uses Caddy on `hal`. Cloudflare provides DNS only;
Cloudflare Tunnel and the orange-cloud proxy are not used.

```text
Internet -> Cloudflare DNS-only records -> Caddy on hal
         -> Tailscale -> Asimov services
```

| Hostname | Asimov origin | Application |
|---|---|---|
| `photos.erdohat.com` | `http://ASIMOV_TAILSCALE_IP:2283` | Immich |
| `drive.erdohat.com` | `http://ASIMOV_TAILSCALE_IP:8081` | Nextcloud |
| `office.erdohat.com` | `http://ASIMOV_TAILSCALE_IP:9980` | ONLYOFFICE |
| `notes.erdohat.com` | `http://ASIMOV_TAILSCALE_IP:8090` | ZenNotes |
| `opencode.erdohat.com` | `http://ASIMOV_TAILSCALE_IP:4096` | OpenCode |

Asimov service ports should remain reachable from the tailnet, not directly
from the public internet.

## 1. DNS

Create five **DNS-only** Cloudflare records pointing to `hal`'s public IPv4:

```text
photos   A     HAL_PUBLIC_IPV4
drive    A     HAL_PUBLIC_IPV4
office   A     HAL_PUBLIC_IPV4
notes    A     HAL_PUBLIC_IPV4
opencode A     HAL_PUBLIC_IPV4
```

Add `AAAA` records only if IPv6 is configured and tested on `hal`. Keep all
records gray-clouded.

## 2. Verify Tailscale origins

```bash
ssh peti@hal
tailscale status
tailscale ip -4

curl -sS -o /dev/null -w 'nextcloud=%{http_code}\n' http://ASIMOV_TAILSCALE_IP:8081/status.php
curl -sS -o /dev/null -w 'onlyoffice=%{http_code}\n' http://ASIMOV_TAILSCALE_IP:9980/welcome/
curl -sS -o /dev/null -w 'zennotes=%{http_code}\n' http://ASIMOV_TAILSCALE_IP:8090/
curl -sS -o /dev/null -w 'opencode=%{http_code}\n' http://ASIMOV_TAILSCALE_IP:4096/
```

ZenNotes must publish port `8090` on Asimov's Tailscale address, not only on
`127.0.0.1`:

```yaml
ports:
  - "ASIMOV_TAILSCALE_IP:8090:7878"
```

Never put ZenNotes tokens or other secrets in this repository.

## 3. Install Caddy on `hal`

Use Caddy's official Ubuntu package instructions. Caddy owns ports `80` and
`443`; the old Nginx service must remain inactive:

```bash
sudo systemctl enable --now caddy
```

Confirm that existing Nginx sites have been migrated or are no longer needed.
Caddy and Nginx cannot both own ports `80` and `443`.

## 4. Configure Caddy

Create `/etc/caddy/Caddyfile` with `sudoedit`. Replace
`ASIMOV_TAILSCALE_IP` and `YOUR_ACME_EMAIL` locally; do not commit the filled
file or any private keys.

```caddyfile
{
    email YOUR_ACME_EMAIL
}

photos.erdohat.com {
    reverse_proxy http://ASIMOV_TAILSCALE_IP:2283 {
        transport http {
            read_timeout 10m
            write_timeout 10m
        }
    }
}

drive.erdohat.com {
    reverse_proxy http://ASIMOV_TAILSCALE_IP:8081 {
        transport http {
            read_timeout 1h
            write_timeout 1h
        }
    }
}

office.erdohat.com {
    reverse_proxy http://ASIMOV_TAILSCALE_IP:9980 {
        transport http {
            read_timeout 1h
            write_timeout 1h
        }
    }
}

notes.erdohat.com {
    reverse_proxy http://ASIMOV_TAILSCALE_IP:8090 {
        transport http {
            read_timeout 1h
            write_timeout 1h
        }
    }
}

opencode.erdohat.com {
    reverse_proxy http://ASIMOV_TAILSCALE_IP:4096
}
```

Validate and start Caddy:

```bash
sudo caddy validate --config /etc/caddy/Caddyfile
sudo systemctl enable --now caddy
sudo systemctl reload caddy
```

Caddy obtains and renews HTTPS certificates automatically. Do not put private
keys, ACME credentials, or application secrets in this repository.

## 5. Application URLs

Run Nextcloud commands on Asimov, where `nextcloud_app` runs:

```bash
sudo docker exec -u www-data nextcloud_app php occ config:system:set trusted_domains 1 --value='drive.erdohat.com'
sudo docker exec -u www-data nextcloud_app php occ config:system:set overwritehost --value='drive.erdohat.com'
sudo docker exec -u www-data nextcloud_app php occ config:system:set overwriteprotocol --value='https'
sudo docker exec -u www-data nextcloud_app php occ config:system:set overwrite.cli.url --value='https://drive.erdohat.com'
```

Add `hal`'s Tailscale address to Nextcloud `trusted_proxies`. Keep the internal
ONLYOFFICE URLs unchanged:

```text
DocumentServerInternalUrl: http://onlyoffice/
StorageUrl: http://nextcloud.wopi.local/
```

Set ONLYOFFICE's public Document Server URL to:

```text
https://office.erdohat.com
```

Keep JWT enabled. Never put its value in this repository, shell history, or
chat messages.

ZenNotes uses its dedicated root URL:

```text
https://notes.erdohat.com
```

Do not use a `/zennotes` base path when it has its own hostname.

OpenCode's existing Basic Auth must remain enabled before exposing this route.
Keep the strong password in `~/.config/opencode/server.env`; never commit or
paste that file or password.

## 6. Verify externally

From a device with Tailscale disabled:

```bash
curl -I https://photos.erdohat.com
curl -I https://drive.erdohat.com/status.php
curl -I https://office.erdohat.com/welcome/
curl -I https://notes.erdohat.com
curl -I https://opencode.erdohat.com
```

Test Immich uploads, Nextcloud login and WebDAV, ONLYOFFICE editing and save
callbacks, ZenNotes browser/phone access, and OpenCode Basic Auth. Do not
re-enable Tailscale Funnel; Caddy on `hal` is the public entry point.
