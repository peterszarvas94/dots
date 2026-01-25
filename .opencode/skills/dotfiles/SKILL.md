---
name: dotfiles
description: Explain this dotfiles repo structure, how to use existing configs, and how to add new ones.
---
# Dotfiles Skill

## Purpose
Help coding agents understand how this repo organizes dotfiles, how to use the existing configs, and how to add new ones.

## Repo structure
- `stow/` contains per-tool packages intended for GNU Stow.
- Each package mirrors the target location under your home directory.
- Example: `stow/neovim/.config/nvim` maps to `~/.config/nvim`.

Major packages in `stow/`:
- `neovim` (Neovim config)
- `zsh` (shell config)
- `tmux` (terminal multiplexer)
- `git` (git config)
- `alacritty`, `ghostty` (terminal emulators)
- `yabai`, `skhd`, `aerospace`, `amethyst` (window managers)
- `karabiner` (keyboard)
- `starship` (prompt)
- `lazygit` (git UI)
- `opencode`, `zed`, `ruby`, `ssh`, `scripts`, `hypr`, `waybar`, `systemd`

## Using the configs
- Use the repo `./config` script from the repo root. It handles package linking plus extra per-tool steps.
- Deploy a single package:

```bash
./config --pkg=neovim
```

- Deploy all packages for the current OS:

```bash
./config --pkg=all
```

## Adding a new config
1. Create a new package folder in `stow/`, named after the tool.
2. Mirror the target path inside that folder (shows where it links to).
3. Put the config files under that mirrored path.

Example for a new tool `foo` that stores config in `~/.config/foo`:

```
stow/foo/.config/foo/
```

Then deploy it:

```bash
./config --pkg=foo
```

## Neovim specifics
- Neovim config lives at `stow/neovim/.config/nvim`.
- Stow `neovim` to link into `~/.config/nvim`.

## Notes for agents
- Do not edit generated or external files (e.g. `node_modules`).
- Keep new configs ASCII unless a file already uses Unicode.
- Prefer small, focused changes that match existing conventions.
