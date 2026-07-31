# Mac Neovim theme runtime package (`stow/nvim-theme-mac`)

## Owns

- `~/.local/share/dots/bin/mac-sync-nvim-theme`
- `~/Library/LaunchAgents/com.peterszarvas.theme-sync.plist`

## Purpose

Keep macOS light/dark appearance synced into Neovim theme state (`~/.config/omarchy/current/theme/neovim.lua`) via a `dark-notify` launchd watcher. Neovim maps dark mode to Rose Pine Moon and light mode to Rose Pine Dawn.

## Usage

- `./config --pkg=nvim` stows this package automatically on macOS and reloads the theme watcher.
- `./config --pkg=nvim-theme-mac` stows only runtime sync files.
