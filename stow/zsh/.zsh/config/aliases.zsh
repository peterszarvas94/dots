# neovim
alias v="nvim"

# gems backend 
alias bdown="docker compose --project-directory ~/work/gems-backend-platform down "
alias bup="docker compose --project-directory ~/work/gems-backend-platform up -d"
alias bdok="bdown && bup"
alias bbuild="cd ~/work/gems-backend-platform && bun run build"
alias bgen="cd ~/work/gems-backend-platform/packages/database && bun run generate:mig"
alias bmig="cd ~/work/gems-backend-platform/packages/database && bun run migrate"
alias binit="cd ~/work/gems-backend-platform/packages/database && bun run init-development"
alias bstart="cd ~/work/gems-backend-platform/packages/app && bun run start"
alias bdev="cd ~/work/gems-backend-platform/packages/app && bun run start:dev"
alias bdebug="cd ~/work/gems-backend-platform/packages/app && bun run start:debug"
alias ball="bbuild && binit && bstart"

# gems frontend
alias fbuild="cd ~/work/gems-frontend-platform && bun run build"
alias fdev="cd ~/work/gems-frontend-platform/packages/app-center && bun run dev"
alias fpre="cd ~/work/gems-frontend-platform/packages/app-center && bun run preview"
alias genapi="cd ~/work/gems-frontend-platform && bun run generate:api"
alias genobject="cd ~/work/gems-frontend-platform && bun run generate:object"

# misc
alias openfile='nvim "$(find . -type f | fzf)"'
alias ftp="termscp"
alias zed="open -a /Applications/Zed.app -n"

# tmux
alias ctmux="cd $(get-tmux-start)"

alias lgit="lazygit"
alias ldocker="lazydocker"

alias conform-log='cat ~/.local/state/nvim/conform.log | less -R'
alias conform-file='nvim ~/.local/state/nvim/conform.log'

alias uuid='uuidgen -r | wl-copy'

# colima systemd service management
alias colima-start='systemctl --user start colima.service'
alias colima-stop='systemctl --user stop colima.service'
alias colima-restart='systemctl --user restart colima.service'
alias colima-status='systemctl --user status colima.service'
alias colima-logs='journalctl --user -u colima.service -f'
alias colima-enable='systemctl --user enable colima.service'
alias colima-disable='systemctl --user disable colima.service'

alias config="$HOME/projects/dots/config"
