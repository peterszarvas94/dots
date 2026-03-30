# Hyprland package (`stow/hypr`)

## Owns

- `~/.config/hypr`

## Main files

- `stow/hypr/.config/hypr/bindings.conf`
- `stow/hypr/.config/hypr/monitors.conf`
- `stow/hypr/.config/hypr/looknfeel.conf`
- `stow/hypr/.config/hypr/autostart.conf`
- `stow/hypr/.config/hypr/input.conf`
- `stow/hypr/.config/hypr/envs.conf`

## Deploy behavior

- `./config --pkg=hypr` updates links and then attempts `hyprctl reload`.

## Typical edits

- Keybindings
- Monitor layout
- Startup apps and environment variables
