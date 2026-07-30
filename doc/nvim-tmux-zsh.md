# Neovim, tmux, and zsh (mac + Omarchy)

macOS and Omarchy use the **same stowed** `zsh`, `nvim`, and `tmux` packages. Platform differences are limited to small shims (e.g. `~/.zsh/mac/platform.zsh` vs `~/.zsh/omarchy/platform.zsh`).

## Source of truth (not `--adopt`)

Omarchy configs were **copied once into the repo** (`rsync` from live `~/.config/…`), then deployed with normal **stow** (symlinks). Dots does **not** point at `/usr/share/omarchy-nvim` or use `stow --adopt` from `$HOME`.

After an Omarchy package update, your nvim/tmux **won’t** change until you merge upstream into `stow/` (or edit stowed files). To refresh from a machine that still tracks Omarchy defaults:

```bash
# Review diff first — overwrites stow tree
rsync -av --delete --exclude lazy-lock.json \
  ~/.config/nvim/ ~/Projects/dots/stow/nvim/.config/nvim/
rsync -av ~/.config/tmux/tmux.conf ~/Projects/dots/stow/tmux/.config/tmux/
```

Re-apply dotfiles-only edits (extra tmux binds, `omarchy/theme.lua` merge, archived `lua-plugins/` if you restored any).

## Neovim

- **Stow:** `stow/nvim/.config/nvim/` → `~/.config/nvim`
- **Base:** Omarchy **LazyVim** layout (`require("config.lazy")`, `lazyvim.json`, etc.)
- **Old custom lazy.nvim config:** archived under [`archive/nvim-dots-lazy-custom/`](../archive/nvim-dots-lazy-custom/) (not deployed)
- **Preserved dotfiles plugins:** archived under [`archive/nvim-dots-lazy-custom/lua-plugins/`](../archive/nvim-dots-lazy-custom/lua-plugins/) (not auto-loaded — they duplicated LazyVim specs). Copy back one file at a time after adapting to LazyVim.
- **Theme:** `./config.sh --pkg=nvim` runs `link_nvim_theme`:
  - Omarchy → `lua/plugins/theme.lua` → `omarchy/theme.lua`
  - macOS → `lua/plugins/theme.lua` → `mac/theme.lua`
- Omarchy-only: `lua/plugins/omarchy-theme-hotreload.lua` (system theme sync)

Deploy:

```bash
./config.sh --pkg=nvim
```

## Tmux

- **Stow:** `stow/tmux/.config/tmux/tmux.conf` → `~/.config/tmux/tmux.conf`
- **Base:** Omarchy tmux config
- **Dotfiles extras:** `branch`, `tmux-sessionizer`, `lazygit`, `lazydocker`, `jjui` at the bottom of the file
- Legacy root `~/.tmux.conf` archived as [`archive/tmux-dots-root.conf`](../archive/tmux-dots-root.conf)

```bash
./config.sh --pkg=tmux
```

## Zsh

- **Stow:** `stow/zsh/` → `~/.zshrc`, `~/.zsh/`
- Shared `~/.zshrc`; mac vs Linux only in `platform.zsh` (Homebrew vs `try`, etc.)

```bash
./config.sh --pkg=zsh
```

## macOS full stack (typical)

```bash
./config.sh --pkg=zsh,nvim,tmux,ssh,scripts
```

After `nvim`, run once: `nvim` (LazyVim will bootstrap plugins).
