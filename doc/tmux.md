# Tmux package (`stow/tmux`)

## Owns

- `~/.tmux.conf`

## Main file

- `stow/tmux/.tmux.conf`

## Notes

- Includes popup bindings for helper tools like `tmux-sessionizer`, `lazygit`, and `lazydocker`.

## Deploy behavior

- `./config --pkg=tmux` updates links and runs `tmux source-file ~/.tmux.conf`.
