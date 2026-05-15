# Neovim Theme Reload Plan (Pull + Push)

## Goal

Make Neovim theme updates resilient by combining:

- Push: Omarchy `theme-set` hook sends `:SyncTheme` to running Neovim instances.
- Pull: Neovim listens for `lazy.nvim` `User LazyReload` events and re-syncs theme locally.

This keeps instant updates on theme switch while also recovering from missed socket pushes.

## Current State (repo)

- Push hook exists: `stow/omarchy/.config/omarchy/hooks/theme-set`.
- Neovim command exists: `SyncTheme` in `stow/nvim/.config/nvim/lua/config/autocmds.lua`.
- No `LazyReload` listener exists in `stow/nvim/.config/nvim`.

## Proposed Changes

1. **Extract shared sync execution**
   - Keep `sync_theme()` as single source of truth.
   - Reuse this function from both `:SyncTheme` and reload event handlers.

2. **Add `User LazyReload` listener**
   - In `stow/nvim/.config/nvim/lua/config/autocmds.lua`, add:
     - `vim.api.nvim_create_autocmd("User", { pattern = "LazyReload", ... })`
   - Callback should call `sync_theme()` and apply result quietly.

3. **Guard against noisy repeats**
   - Track last applied tuple (`colorscheme`, `background`) in a local Lua variable.
   - Skip UI echo unless the theme actually changed.

4. **Keep push hook unchanged (for now)**
   - Continue using remote-send from Omarchy hook for immediate cross-instance update.
   - Pull path acts as fallback and self-healing mechanism.

5. **Optional enhancement (phase 2)**
   - Add `BufWritePost` watcher for `~/.config/omarchy/current/theme/neovim.lua`.
   - Only needed if `LazyReload` misses symlink target changes in some environments.

## Validation Checklist

1. Start two Neovim instances.
2. Run `omarchy theme set <theme>`.
3. Verify both instances update without restart.
4. Edit `~/.config/omarchy/current/theme/neovim.lua` and save.
5. Confirm `LazyReload` path applies new theme mapping.
6. Confirm no repeated or noisy messages during normal editing.

## Rollback

- Remove only the `User LazyReload` autocmd block from `autocmds.lua`.
- Keep `SyncTheme` command + Omarchy hook as existing stable baseline.
