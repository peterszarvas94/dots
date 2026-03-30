# Dotfiles

## Purpose

Reference for how this repo is laid out and which files/folders are responsible for setup, deployment, and reusable assets.

## Top-level layout

- `stow/`: Main dotfiles packages managed by GNU Stow.
- `config`: Main deploy script (`--pkg`, `--git`, `--services`, `--debloat`) with platform-aware linking.
- `setup_mac`: Bootstrap script for macOS package install + clone + initial `./config` run.
- `setup_omarchy`: Bootstrap script for Linux/Omarchy package install + clone + initial `./config` run.
- `doc/`: Repository documentation (this file lives here).
- `resources/`: Extra assets like fonts, wallpapers, keyboard layout, and `mise` related files.
- `_old/`: Archived legacy configs/scripts kept for reference.
- `README.md`: Quick-start instructions for macOS and Omarchy setup.
- `TODO.md`: Short project backlog notes.

## `stow/` packages

Current packages:

- `ghostty`, `git`, `hypr`, `lazygit`, `nvim`, `omarchy`, `opencode`, `scripts`
- `ssh`, `systemd`, `tmux`, `waybar`, `xdg`, `zed`, `zsh`

Each package mirrors the target path under `$HOME`.

Example:

```text
stow/nvim/.config/nvim -> ~/.config/nvim
```

## Major packages

For the packages you are most likely to edit first, see:

- `doc/major-packages.md`

It covers what each package owns, where platform-specific files live, and which files are safe to tweak directly.

## Common usage

Deploy all packages for the current platform:

```bash
./config --pkg=all
```

Deploy one package:

```bash
./config --pkg=nvim
```

Optional extra actions:

```bash
./config --git
./config --services
./config --debloat
```

## Adding a new package

1. Create a folder under `stow/` named after the tool.
2. Mirror the destination path inside that folder.
3. Add files, then deploy with `./config --pkg=<name>`.

Example structure:

```text
stow/foo/.config/foo/
```

## Notes

- The `config` script auto-detects platform (`mac` or `omarchy`).
- Theme/platform links for tools like `nvim`, `ghostty`, and `zsh` are handled by `config` after stow deploy.
- Keep changes focused and consistent with existing folder conventions.
