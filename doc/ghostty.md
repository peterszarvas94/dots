# Ghostty package (`stow/ghostty`)

## Owns

- `~/.config/ghostty` (macOS and headless Linux server only; **not** deployed on Omarchy)

## Main files

- Base config: `stow/ghostty/.config/ghostty/config`
- macOS overrides: `stow/ghostty/.config/ghostty/mac/`

## Platform behavior

- **Omarchy:** Dotfiles do not deploy or link Ghostty. Use Omarchy’s default terminal config (`omarchy refresh config ghostty/config` if you need to reset).
- **macOS:** `./config` deploys this package and links `theme.conf` / `settings.conf` from `stow/ghostty/.config/ghostty/mac/`.
