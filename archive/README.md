# Archive (not stowed)

Snapshots kept in git for reference; not deployed by `./config.sh`.

## `nvim-dots-lazy-custom/`

Previous **dots** Neovim setup: standalone `lazy.nvim` (not LazyVim), custom `lua/config/*`, plugins under `lua/plugins/`, Tree-sitter parsers under `parsers/`, `after/plugin/*`.

Replaced by **Omarchy LazyVim** layout in `stow/nvim/.config/nvim/` (mirrored from `~/.config/nvim` on Omarchy).

Custom plugins from the old setup were copied into the stowed LazyVim tree as `lua/plugins/dots-*.lua` and `after/plugin/dots-*.lua`.

Those **`dots-*` files are archived under `nvim-dots-lazy-custom/lua-plugins/`** (and `after-plugin/`) because they duplicate LazyVim specs (second `conform`, `neo-tree`, etc.) and break startup. Re-enable individually by copying back into `stow/nvim/.config/nvim/lua/plugins/` and adapting to LazyVim `opts` style.

Shared helper **`lua/config/ts_lsp.lua`** remains in stow for organize-imports if you merge that into `conform.lua`.

## `tmux-dots-root.conf`

Former root-level `~/.tmux.conf` from stow. Tmux now uses `stow/tmux/.config/tmux/tmux.conf` (Omarchy base + dotfiles binds at the bottom).
