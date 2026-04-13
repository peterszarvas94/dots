# omarchy

- [ ] Add `stow/ghostty/.config/ghostty/omarchy/theme.conf` with `theme = light:Rose Pine Dawn,dark:Rose Pine`
- [ ] Add `stow/nvim/.config/nvim/omarchy/theme.lua` based on mac version:
  - [ ] detect dark/light from `gsettings get org.gnome.desktop.interface color-scheme`
  - [ ] set `vim.o.background` (`dark` or `light`)
  - [ ] apply `colorscheme rose-pine`
  - [ ] live refresh on `FocusGained` + `VimEnter`
- [ ] Update `config` omarchy linking:
  - [ ] ghostty: link `~/.config/ghostty/omarchy/theme.conf` -> `~/.config/ghostty/theme.conf`
  - [ ] nvim: link `~/.config/nvim/omarchy/theme.lua` -> `~/.config/nvim/lua/plugins/theme.lua`
  - [ ] keep existing omarchy settings links unchanged
- [ ] Keep Neovim on Rose Pine only across platforms
- [ ] Omarchy test checklist:
  - [ ] `./config --pkg=ghostty`
  - [ ] `./config --pkg=nvim`
  - [ ] switch system theme dark/light and verify Ghostty updates
  - [ ] switch system theme dark/light and verify Neovim updates after focus change
  - [ ] verify no regressions in tmux/waybar/hypr theme integration

# kb

- add layout file
