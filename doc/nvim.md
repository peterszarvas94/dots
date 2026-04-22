# Neovim package (`stow/nvim`)

## Owns

- `~/.config/nvim`

## Main files

- Entry: `stow/nvim/.config/nvim/init.lua`
- Core config: `stow/nvim/.config/nvim/lua/config/`
- Plugin specs (including theme runtime logic): `stow/nvim/.config/nvim/lua/plugins/`

## Platform behavior

`./config` links theme files differently per platform:

- macOS: `stow/nvim/.config/nvim/lua/plugins/theme.lua` uses `~/.config/omarchy/current/theme/neovim.lua`
- omarchy: `stow/nvim/.config/nvim/lua/plugins/theme.lua` uses `~/.config/omarchy/current/theme/neovim.lua`

On macOS, `./config --pkg=nvim` also deploys `nvim-theme-mac` and reloads the launchd watcher (`dark-notify`) that keeps `~/.config/omarchy/current/theme/neovim.lua` updated from system light/dark mode.

## Typical edits

- Keymaps and options
- LSP and format/lint setup
- Plugin configuration
