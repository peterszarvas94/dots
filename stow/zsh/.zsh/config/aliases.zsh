# neovim
alias v="nvim"

# tmux
alias ts="tmux-sessionizer"
alias ta="tmux-attach"
alias tk="tmux kill-server"
alias tn="tmux-new"

get_tmux_start_path() {
    session_start_path=$(tmux display-message -p -t $(tmux display-message -p '#S'):0.0 "#{pane_start_path}")
    if [ -z "$session_start_path" ]; then
        session_start_path=$(tmux display-message -p -t $(tmux display-message -p '#S'):0.0 "#{pane_current_path}")
    fi
    echo "$session_start_path"
}

# cd tmux start path
ct() {
    cd "$(get_tmux_start_path)"
}

# nvim tmux start path
vt() {
    nvim "$(get_tmux_start_path)"
}

vd() {
    cd "$(get_tmux_start_path)" && v
}


# gems backend 
alias bdown="cd ~/work/gems-backend-platform && docker compose down"
alias bup="cd ~/work/gems-backend-platform && docker compose up -d"
alias bdok="bdown && bup"
alias bbuild="cd ~/work/gems-backend-platform && npm run build"
alias bgen="cd ~/work/gems-backend-platform/packages/database && npm run generate:mig"
alias bmig="cd ~/work/gems-backend-platform/packages/database && npm run migrate"
alias binit="cd ~/work/gems-backend-platform/packages/database && npm run init-development"
alias bstart="cd ~/work/gems-backend-platform/packages/app && npm run start"
alias bdebug="cd ~/work/gems-backend-platform/packages/app && npm run start:debug"
alias ball="bbuild && binit && bstart"

# gems frontend
alias fbuild="cd ~/work/gems-frontend-platform && npm run build"
alias fgen="api && objecttypes"
alias fdev="cd ~/work/gems-frontend-platform/packages/app-gems && npm run dev"
alias fpre="cd ~/work/gems-frontend-platform/packages/app-gems && npm run preview"

# lazygit
alias lg="lazygit"
alias td="tmux-dots"
alias cl="clear"
alias gob="gobang"

# fzf
alias fc="fzf-checkout"
alias fd="fzf-diff"
alias fs="fzf-stash"
alias ff='nvim "$(find . -type f | fzf)"'

alias la="ls -la"

alias ke="killall eslint_d"

alias kp="killport"

# ftp
alias ftp="termscp"

# zed
alias zed="open -a /Applications/Zed.app -n"

# git
alias gpo="push-origin"
alias gcm="commit"
alias gst="git status"
alias gd="git diff"
alias gr="git rebase"
alias gpf="git push --force-with-lease"
alias gfpa="git fetch --prune --all"
alias gsc="git switch -c"
alias gp="git pull"

# nvim
alias cn="cd ~/.config/nvim"
alias nn="tmux-nvim"
