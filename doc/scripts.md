# Scripts package (`stow/scripts`)

## Owns

- `~/.local/share/dots/bin`

## Purpose

Small local CLI tools used by shell, tmux, Hyprland, and Waybar workflows.

`~/.local/bin` is left for third-party installs (npm globals, Cursor agent, AppImages, etc.).

## High-usage scripts

- `stow/scripts/.local/share/dots/bin/theme`: toggles desktop dark/light preference with `gsettings`.
- `stow/scripts/.local/share/dots/bin/tmux-sessionizer`: fuzzy-select directory and switch/create tmux session.
- `stow/scripts/.local/share/dots/bin/herdr-sessionizer`: fuzzy-select an existing Herdr session and attach to it.
- `stow/scripts/.local/share/dots/bin/branch`: fuzzy git branch checkout helper.
- `stow/scripts/.local/share/dots/bin/wifi-password`: fuzzy-select a saved Wi-Fi network and print its password on macOS or Linux.
- `stow/scripts/.local/share/dots/bin/omarchy-cmd-screenrecord`: recording workflow with Waybar signal support and optional post hook.
