# SSH setup

How this repo configures OpenSSH on the dev machine: local key files, `ssh-agent`, and optional export from 1Password.

Private keys and `known_hosts` stay **only** on the machine under `~/.ssh/` — they are **not** in git.

## Stow packages

| Path in repo                   | Deploys to          | Role                                         |
| ------------------------------ | ------------------- | -------------------------------------------- |
| `stow/ssh/.ssh/config.example` | (template, tracked) | Default client config                        |
| `stow/ssh/.ssh/config`         | `~/.ssh/config`     | Local copy (gitignored); seeded from example |
| `stow/zsh/.zshrc` (tail)       | `~/.zshrc`          | Start `ssh-agent`, `ssh-add` listed keys     |

`config` is gitignored. Setup / `./config --pkg=ssh` copies `config.example` → `config` when missing, then stows it.

Deploy (removes prior **stow-managed** paths for these packages, then links fresh):

```bash
./config.sh --pkg=ssh,zsh,scripts
```

`config.sh` unstows and deletes only what those packages own (`~/.ssh/config`, `~/.ssh/config.example`, `~/.zshrc`, `~/.zsh/`, `~/.local/share/dots/bin/*`) — not private keys or `known_hosts`.

## Client config (`~/.ssh/config`)

Current layout:

- **`Include ~/.config/colima/ssh_config*`** — Colima VM SSH entries when present (glob so missing file is a no-op on Mac and Linux).
- **`Host *`** — one block for all hosts:
  - **`AddKeysToAgent yes`** — keys used for login are added to the agent when possible.
  - **`IdentitiesOnly yes`** — only offer keys listed below (and/or loaded in the agent when combined with `IdentityFile`; see below).
  - **`IdentityFile ~/.ssh/<name>`** — one line per globally available key file (github, hetzner, servers, etc.).

Dedicated hosts may use a per-host key under `~/.ssh/`; other hosts use the
global key list. The server must accept the matching public key.

Previously this repo used **1Password** as the only backend:

```sshconfig
Host *
  IdentityAgent ~/.1password/agent.sock
```

That breaks headless services (e.g. OpenCode web) that do not run zsh or 1Password. The file-based + agent setup avoids that for interactive use.

## Zsh and `ssh-agent`

On desktop zsh startup (see `stow/zsh/.zshrc`):

1. If **`SSH_AUTH_SOCK`** is unset or **`ssh-add -l`** fails → run **`eval "$(ssh-agent -s)"`**.
2. **`ssh-add`** each required private key under `~/.ssh/`.

### What `SSH_AUTH_SOCK` is

Environment variable pointing at the Unix socket for **ssh-agent**. `ssh` and `git` use it to use passphrases-loaded keys without re-reading disk every time.

Check:

```bash
echo "$SSH_AUTH_SOCK"
ssh-add -l
```

- Empty or “Could not open a connection” → start agent (new terminal after zsh fix, or `eval "$(ssh-agent -s)"` + `ssh-add`).
- Still pointing at `~/.1password/agent.sock` → remove old 1Password export from shell config.

With **`IdentityFile`** in `config`, **`ssh -T git@github.com`** can still work **without** an agent (reads `~/.ssh/github` directly). The agent avoids repeated passphrases and helps tools that only talk to the agent.

### Restart agent and test

```bash
ssh-agent -k 2>/dev/null
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github ~/.ssh/hetzner   # or your full list
ssh-add -l
ssh -T git@github.com
```

## Export keys from 1Password

Script: **`dump-ssh-keys`** (`stow/scripts` → `~/.local/share/dots/bin/dump-ssh-keys`).

```bash
dump-ssh-keys --dry-run
dump-ssh-keys              # writes ~/.ssh/<title> and ~/.ssh/<title>.pub
dump-ssh-keys --force      # overwrite existing files
```

Uses **`op item list --categories "SSH Key"`** and **`op item get <id>`** (vault default: **Private**, override with `--vault` or `OP_SSH_VAULT`).

Private keys are written in **OpenSSH** format (`ssh_formats.openssh` / `?ssh-format=openssh`). The default 1Password field value is often PKCS#8 (`BEGIN PRIVATE KEY`), which OpenSSH on **macOS and Linux** commonly rejects as `invalid format`.

After export:

1. Add any new basenames to **`IdentityFile`** lines in `stow/ssh/.ssh/config`.
2. Add matching **`ssh-add`** lines in `stow/zsh/.zshrc`.
3. Ensure public keys are registered on GitHub / server `authorized_keys` (export does not upload anywhere).

## OpenCode web / systemd

`opencode-web` does **not** source `.zshrc`. It will not get your interactive `SSH_AUTH_SOCK` unless you configure it.

Options:

- Set **`GIT_SSH_COMMAND`** in `~/.config/opencode/server.env`, e.g.  
  `GIT_SSH_COMMAND=ssh -i ~/.ssh/github -o IdentitiesOnly=yes`
- Or point **`SSH_AUTH_SOCK`** in that env file at a long-lived user agent (fragile after reboot).

See [opencode-host.md](./opencode-host.md) for the web service layout.

## Security notes

- Never commit `~/.ssh/*` private keys or `authorized_keys` from servers.
- **`dump-ssh-keys --force`** overwrites local keys; keep 1Password items until you confirm login everywhere.
- Prefer **`IdentitiesOnly yes`** so SSH does not offer every default key to GitHub and leak cross-account attempts.

## Related scripts

| Script             | Purpose                                                            |
| ------------------ | ------------------------------------------------------------------ |
| `dump-ssh-keys`    | 1Password → `~/.ssh/`                                              |
| `bootstrap-github` | New GitHub SSH key + `gh ssh-key add` (legacy file-based flow)     |
| `ssh_server_setup` | Initial server hardening + install a `.pub` into `authorized_keys` |
