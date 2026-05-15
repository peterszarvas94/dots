# Neovim package (`stow/nvim`)

## Owns

- `~/.config/nvim`

## Main files

- Entry: `stow/nvim/.config/nvim/init.lua`
- Core config: `stow/nvim/.config/nvim/lua/config/`
- Plugin specs (including theme runtime logic): `stow/nvim/.config/nvim/lua/plugins/`
- Tree-sitter installer script: `install_treesitter_parsers.sh`

## Platform behavior

`./config` links theme files differently per platform:

- macOS: `stow/nvim/.config/nvim/lua/plugins/theme.lua` uses `~/.config/omarchy/current/theme/neovim.lua`
- omarchy: `stow/nvim/.config/nvim/lua/plugins/theme.lua` uses `~/.config/omarchy/current/theme/neovim.lua`

On macOS, `./config --pkg=nvim` also deploys `nvim-theme-mac` and reloads the launchd watcher (`dark-notify`) that keeps `~/.config/omarchy/current/theme/neovim.lua` updated from system light/dark mode.

## Typical edits

- Keymaps and options
- LSP and format/lint setup
- Plugin configuration

## Tree-sitter management

This setup uses a local parser+query install directory and prepends it to `runtimepath`:

- `stow/nvim/.config/nvim/lua/config/options.lua`
- `stow/nvim/.config/nvim/init.lua`

Parsers and bundled queries are installed by:

```bash
./install_treesitter_parsers.sh
```

Install target:

- Parsers: `~/.config/nvim/parsers/parser/*.so`
- Queries: `~/.config/nvim/parsers/queries/<lang>/*.scm`

### Why this script exists

- `nvim-treesitter/nvim-treesitter` was archived/deprecated, so parser/query management is handled here directly.
- This keeps parser install/update behavior explicit and versionable in this repo.

### Compatibility safeguards

- SQL has a language-specific post-process fix for numeric regex patterns in `highlights.scm`.
- A global normalization pass removes unsupported `#is-not? local` query predicates to prevent runtime errors on Neovim versions that do not implement that predicate handler.
