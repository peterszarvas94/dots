# neovim
alias v="nvim"

# gems backend 
alias bdown="cd ~/work/gems-backend-platform && docker compose down"
alias bup="cd ~/work/gems-backend-platform && docker compose up -d"
alias bdok="bdown && bup"
alias bbuild="cd ~/work/gems-backend-platform && npm run build"
alias bgen="cd ~/work/gems-backend-platform/packages/database && npm run generate:mig"
alias bmig="cd ~/work/gems-backend-platform/packages/database && npm run migrate"
alias binit="cd ~/work/gems-backend-platform/packages/database && npm run init-development"
alias bstart="cd ~/work/gems-backend-platform/packages/app && npm run start"
alias bdev="cd ~/work/gems-backend-platform/packages/app && npm run start:dev"
alias bdebug="cd ~/work/gems-backend-platform/packages/app && npm run start:debug"
alias ball="bbuild && binit && bstart"

# gems frontend
alias fbuild="cd ~/work/gems-frontend-platform && npm run build"
alias fdev="cd ~/work/gems-frontend-platform/packages/app-gems && npm run dev"
alias fpre="cd ~/work/gems-frontend-platform/packages/app-gems && npm run preview"
alias genapi="cd ~/work/gems-frontend-platform && npm run generate:api"
alias genobject="cd ~/work/gems-frontend-platform && npm run generate:object"

# misc
alias openfile='nvim "$(find . -type f | fzf)"'
alias ftp="termscp"
alias zed="open -a /Applications/Zed.app -n"

# tmux
alias ctmux="cd $(get-tmux-start)"
