# Ghostty package (`stow/ghostty`)

## Owns

- `~/.config/ghostty`

## Main files

- Base config: `stow/ghostty/.config/ghostty/config`
- macOS overrides: `stow/ghostty/.config/ghostty/mac/`
- omarchy overrides: `stow/ghostty/.config/ghostty/omarchy/`

## Platform behavior

`./config` links these after deploy:

- macOS: `theme.conf` from `stow/ghostty/.config/ghostty/mac/theme.conf` and `settings.conf` from `stow/ghostty/.config/ghostty/mac/`
- omarchy: `settings.conf` from `stow/ghostty/.config/ghostty/omarchy/` and `theme.conf` from `~/.config/omarchy/current/theme/ghostty.conf`
