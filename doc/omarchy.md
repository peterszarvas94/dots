# Omarchy package (`stow/omarchy`)

## Owns

- `~/.config/omarchy/hooks`
- `~/.config/omarchy/branding`

## Main files

- Hooks: `stow/omarchy/.config/omarchy/hooks/`
- Branding: `stow/omarchy/.config/omarchy/branding/`
  - `about.txt` — About dialog ASCII art (`omarchy branding about`)
  - `screensaver.txt` — Screensaver ASCII art (`omarchy branding screensaver`)

## Deploy

```bash
./config.sh --pkg=omarchy
```

Branding is stowed to `~/.config/omarchy/branding/` and replaced on redeploy (see `config.sh` omarchy cleanup).

## Notable customization

- `stow/omarchy/.config/omarchy/hooks/screenrecord-post` post-processes recordings after `omarchy-cmd-screenrecord`.
- Edit branding with `omarchy branding about text` / `omarchy branding screensaver text`, then copy changes back into `stow/omarchy/.config/omarchy/branding/`.
