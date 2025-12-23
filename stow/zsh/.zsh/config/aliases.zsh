# neovim
alias v="nvim"

# gems backend 
alias bdown="docker compose --project-directory ~/work/gems-backend-platform down "
alias bup="docker compose --project-directory ~/work/gems-backend-platform up -d"
alias bdok="bdown && bup"
alias bbuild="npm run build -C ~/work/gems-backend-platform"
alias bgen="npm run generate:mig -C ~/work/gems-backend-platform/packages/database"
alias bmig="npm run migrate -C ~/work/gems-backend-platform/packages/database"
alias binit="npm run init-development -C ~/work/gems-backend-platform/packages/database"
alias bstart="npm run start -C ~/work/gems-backend-platform/packages/app"
alias bdev="npm run start:dev -C ~/work/gems-backend-platform/packages/app"
alias bdebug="npm run start:debug -C ~/work/gems-backend-platform/packages/app"
alias ball="bbuild && binit && bstart"

# gems frontend
alias fbuild="npm run build -C ~/work/gems-frontend-platform"
alias fdev="npm run dev -C ~/work/gems-frontend-platform/packages/app-center"
alias fpre="npm run preview -C ~/work/gems-frontend-platform/packages/app-center"
alias genapi="npm run generate:api -C ~/work/gems-frontend-platform"
alias genobject="npm run generate:object -C ~/work/gems-frontend-platform"

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

alias config="$HOME/projects/dots/config"

alias wip="git add . && git commit -m 'wip' --no-verify && git push"
alias amend="git add . && git commit --amend --no-edit && git push"
