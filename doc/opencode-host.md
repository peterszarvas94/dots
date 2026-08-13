# OpenCode on a Development Host

Native [OpenCode](https://opencode.ai/docs/) web UI on the development host.
The host provides the local toolchain and project files; it is not a container
deployment.

## Access model

Use the local web UI for development and a private network or authenticated
reverse proxy for remote access. Keep the service listener, private network
addresses, public hostname, and proxy origin in private operational notes.

HTTP Basic Auth is required for every non-local connection. Do not expose local
development proxies or arbitrary development servers.

## Setup

Install the OpenCode configuration and user service from this repository, then
authenticate the provider locally. Keep service environment files outside git,
with restrictive file permissions:

```bash
umask 077
mkdir -p ~/.config/opencode
touch ~/.config/opencode/server.env
chmod 600 ~/.config/opencode/server.env
```

Set the server username and a strong randomly generated password in that file.
Never commit or paste it.

Enable the user service with the platform's normal service-management commands.
Confirm locally that unauthenticated requests are rejected and authenticated
requests succeed.

## Linux project paths

Linux paths are case-sensitive. Use the canonical casing of project directories
when opening projects in the web UI. If needed, create local symlinks to match
the casing expected by existing sessions, then start a new session.

## Provider notes

The provider login and local OAuth integration must remain on the development
host. Do not publish its local callback or proxy listener. Reapply the local
provider patch after dependency updates if the setup requires one.

## Security

- Require strong Basic Auth for remote access.
- Keep the service behind a private network or authenticated reverse proxy.
- Do not use public tunnels for OpenCode or arbitrary development ports.
- Never commit environment files, auth databases, real hostnames, IPs, ports,
  paths, tokens, or passwords.

## Troubleshooting

**Unauthenticated requests return `401`**

This is expected. Check the configured credentials only on the host.

**The web UI cannot open a project**

Check path casing and start a new session after correcting it.

**Remote access fails**

Check private-network membership, proxy health, host availability, and the
user-service status. Keep detailed addresses and listener values in private
operational documentation.
