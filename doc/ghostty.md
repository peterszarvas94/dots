# Ghostty package (`stow/ghostty`)

## Owns

- `~/.config/ghostty`

## Main files

- Base config: `stow/ghostty/.config/ghostty/config`
- macOS overrides: `stow/ghostty/.config/ghostty/mac/`
- omarchy overrides: `stow/ghostty/.config/ghostty/omarchy/`

## Platform behavior

`./config` links these after deploy:

- macOS: `theme.conf` from `~/.config/omarchy/current/theme/ghostty.conf` and `settings.conf` from `stow/ghostty/.config/ghostty/mac/`
- omarchy: `settings.conf` from `stow/ghostty/.config/ghostty/omarchy/` and `theme.conf` from `~/.config/omarchy/current/theme/ghostty.conf`

On macOS, `./config --theme` updates `~/.config/omarchy/current/theme/ghostty.conf` from system light/dark mode.
