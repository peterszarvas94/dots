# Neovim package (`stow/nvim`)

## Owns

- `~/.config/nvim`

## Main files

- Entry: `stow/nvim/.config/nvim/init.lua`
- Core config: `stow/nvim/.config/nvim/lua/config/`
- Plugin specs (including theme runtime logic): `stow/nvim/.config/nvim/lua/plugins/`

## Platform behavior

`./config` links the shared Omarchy-based configuration on both platforms and links the theme implementation differently:

- macOS: Rose Pine follows the generated macOS appearance state (`rose-pine-moon`/`rose-pine-dawn`)
- omarchy: `stow/nvim/.config/nvim/lua/plugins/theme.lua` uses `~/.config/omarchy/current/theme/neovim.lua`

On macOS, `./config --pkg=nvim` also deploys `nvim-theme-mac` and reloads the launchd watcher (`dark-notify`). The watcher updates the generated state and tells running Neovim instances to switch between Moon and Dawn.

## Typical edits

- Keymaps and options
- LSP and format/lint setup
- Plugin configuration

## Tree-sitter management

This setup uses `neovim-treesitter/nvim-treesitter` on the `main` branch (a community registry-based fork) and installs parsers through plugin config:

- Spec: `stow/nvim/.config/nvim/lua/plugins/treesitter.lua`
- Update command: `:TSUpdate`
- Required CLI: `tree-sitter` must be installed via the system package manager (e.g. `brew install tree-sitter-cli`)

The parser list is managed in `treesitter.install` and synced by Lazy during normal plugin updates.
