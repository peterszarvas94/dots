# Omarchy package (`stow/omarchy`)

## Owns

- `~/.config/omarchy/hooks`
- `~/.config/omarchy/branding`
- `~/.config/ghostty/config`

## Main files

- Hooks: `stow/omarchy/.config/omarchy/hooks/`
- Branding: `stow/omarchy/.config/omarchy/branding/`
  - `about.txt` — About dialog ASCII art (`omarchy branding about`)
  - `screensaver.txt` — Screensaver ASCII art (`omarchy branding screensaver`)
- Ghostty: `stow/omarchy/.config/ghostty/config`

## Deploy

```bash
./config.sh --pkg=omarchy
```

Branding is stowed to `~/.config/omarchy/branding/` and replaced on redeploy (see `config.sh` omarchy cleanup). The Ghostty config is stowed to `~/.config/ghostty/config`; Omarchy's generated theme remains loaded from `~/.config/omarchy/current/theme/ghostty.conf`.

## Notable customization

- `stow/omarchy/.config/omarchy/hooks/screenrecord-post` post-processes recordings after `omarchy-cmd-screenrecord`.
- Edit branding with `omarchy branding about text` / `omarchy branding screensaver text`, then copy changes back into `stow/omarchy/.config/omarchy/branding/`.
