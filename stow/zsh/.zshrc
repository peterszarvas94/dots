export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="peti"

# git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
# git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# List of plugins to load
plugins=(git fzf-tab zsh-autosuggestions zsh-syntax-highlighting)

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

#fzf theme
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export NODE_OPTIONS="--max-old-space-size=4096"

# scripts
export PATH="$HOME/.local/bin:$PATH"

# github ssh
if [[ -o interactive ]]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/github > /dev/null 2>&1
    ssh-add ~/.ssh/digitalocean > /dev/null 2>&1
fi

# go
export PATH=$PATH:/usr/local/go/bin
export GOPATH="$HOME/go"
export PATH=$GOPATH/bin:$PATH

# brew
export PATH=$PATH:/opt/homebrew/bin

# source <(fzf --zsh)

# environment
# export BROWSER='arc'
export EDITOR='nvim'
export VISUAL='nvim'
export TERM='xterm-256color'

# bun completions
# [ -s "/home/peti/.bun/_bun" ] && source "/home/peti/.bun/_bun"
[ -s "/Userds/szarvaspeter/.bun/_bun" ] && source "/Users/szarvaspeter/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# turso
export PATH="~/.turso:$PATH"

# tmux-sessionizer
alias ts="tmux-sessionizer"

# vi mode
bindkey -v
export KEYTIMEOUT=1
# for bash:
# set -o vi

# neovim
alias v="nvim"

# tmux
alias ta="tmux a"
alias tk="tmux kill-server"
alias tn="tmux-new"

get_tmux_start_path() {
    session_start_path=$(tmux display-message -p -t $(tmux display-message -p '#S'):0.0 "#{pane_start_path}")
    if [ -z "$session_start_path" ]; then
        session_start_path=$(tmux display-message -p -t $(tmux display-message -p '#S'):0.0 "#{pane_current_path}")
    fi
    echo "$session_start_path"
}

ct() {
    cd "$(get_tmux_start_path)"
}

vt() {
    nvim "$(get_tmux_start_path)"
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
alias ball="bbuild && binit && bstart"

# gems frontend
alias fbuild="cd ~/work/gems-frontend-platform && npm run build"
alias fgen="openapi"
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

alias ke="killall eslint_d"

alias ga="git add"
alias gcm="git commit"
alias gca="git commit --amend"
alias gb="git branch"
alias gch="git checkout"
alias gcb="git checkout -b"
alias gps="git push"
alias gpl="git pull"
alias gd="git diff"
alias glg="git log --decorate --graph --oneline"
alias gwt="git worktree"

# ftp
alias ftp="termscp"
