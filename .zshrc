# zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

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

# environment
export BROWSER='google-chrome-stable'
export EDITOR='nvim'
export VISUAL='nvim'
export TERM='xterm-256color'

# bun complcd ~/projects/dots && tmuxetions
[ -s "/home/peti/.bun/_bun" ] && source "/home/peti/.bun/_bun"
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

# control+f to open tmux-sessionizer
bindkey -s '^F' 'tmux-sessionizer\n'

# neovim
alias v="nvim"

# tmux
alias ta="tmux a"
alias tk="tmux kill-server"

# gems backend 
alias bdown="cd ~/projects/gems-backend-platform && docker compose down"
alias bup="cd ~/projects/gems-backend-platform && docker compose up -d"
alias bd="bdown && bup"
alias bbuild="cd ~/projects/gems-backend-platform && npm run build"
alias binit="cd ~/projects/gems-backend-platform/packages/database && npm run init-development"
alias bstart="cd ~/projects/gems-backend-platform/packages/app && npm run start"
alias ba="bbuild && binit && bstart"

# gems frontend
alias fb="cd ~/projects/gems-frontend-platform && npm run build"
alias fg="cd ~/projects/gems-frontend-platform/packages/apiclient && npm run generate"
alias fd="cd ~/projects/gems-frontend-platform/packages/app-gems && npm run dev"

# lazygit
alias lg="lazygit"
alias td="tmux-dots"
alias cl="clear"
alias gob="gobang"

# fzf
alias fc="fzf-checkout"
