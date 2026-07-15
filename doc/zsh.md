# Zsh package (`stow/zsh`)

## Owns

- `~/.zshrc`
- `~/.zsh/`

## Main files

- Startup: `stow/zsh/.zshrc`
- Platform profile target: `~/.zsh/config/platform.zsh`

## Platform behavior

`./config` links one platform file to `~/.zsh/config/platform.zsh`:

- macOS: `stow/zsh/.zsh/mac/platform.zsh`
- omarchy: `stow/zsh/.zsh/omarchy/platform.zsh`
- server: `stow/zsh/.zsh/server/platform.zsh` (headless Linux without omarchy)

On server, `.zshrc` loads `stow/zsh/.zsh/server/rc.zsh` instead of the full desktop config (plugins, aliases, docker/mise/zoxide, etc.). Put `~/.machine_report.sh` on the server to show the TR-100 report on login (same as the old `~/.bashrc` hook).

## Notes

- Local machine secrets/env should stay in `~/.zsh/config/env.zsh` (created by deploy, not versioned).
- `stow/zsh/.zsh/plugins/` includes vendored plugin sources; prefer editing `stow/zsh/.zsh/config/` first.
