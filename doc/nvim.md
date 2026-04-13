# Neovim package (`stow/nvim`)

## Owns

- `~/.config/nvim`

## Main files

- Entry: `stow/nvim/.config/nvim/init.lua`
- Core config: `stow/nvim/.config/nvim/lua/config/`
- Plugin specs: `stow/nvim/.config/nvim/lua/plugins/`

## Platform behavior

`./config` links theme files differently per platform:

- macOS: Neovim plugin file `stow/nvim/.config/nvim/mac/theme.lua` reads `~/.config/omarchy/current/theme/neovim.lua`
- omarchy: `stow/nvim/.config/nvim/omarchy/omarchy-theme-preload.lua` and `~/.config/omarchy/current/theme/neovim.lua`

On macOS, `./config --theme` sets up a launchd watcher that keeps `~/.config/omarchy/current/theme/neovim.lua` updated from system light/dark mode.

## Typical edits

- Keymaps and options
- LSP and format/lint setup
- Plugin configuration
