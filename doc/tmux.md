# Tmux package (`stow/tmux`)

## Owns

- `~/.config/tmux/tmux.conf`

## Main file

- `stow/tmux/.config/tmux/tmux.conf`

## Notes

- Shared macOS and Omarchy configuration based on the older dotfiles setup.
- Includes pane navigation and bindings for helper tools like `lazygit` and `lazydocker`.

## Deploy behavior

- `./config --pkg=tmux` updates links and runs `tmux source-file ~/.config/tmux/tmux.conf`.
