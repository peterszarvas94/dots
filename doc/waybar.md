# Waybar package (`stow/waybar`)

## Owns

- `~/.config/waybar`

## Main files

- `stow/waybar/.config/waybar/config.jsonc`
- `stow/waybar/.config/waybar/style.css`

## Notes

- Module actions rely on Omarchy helper commands.

## Deploy behavior

- `./config --pkg=waybar` updates links and then attempts `omarchy-restart-app waybar`.
