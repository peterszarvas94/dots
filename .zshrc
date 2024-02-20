# zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# scripts
export PATH="$HOME/.local/bin:$PATH"

# github ssh
# firs run: eval $(keychain --eval --agents ssh)
if [[ -o interactive ]]; then
    # eval "$(keychain --eval --agents ssh --quiet --inherit any --quick ~/.ssh/github)"
    # eval "$(keychain --eval --agents ssh --quiet --inherit any --quick ~/.ssh/gitlab)"
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/github > /dev/null 2>&1
fi

# Control+F to open tmux-sessionizer
bindkey -s '^F' 'tmux-sessionizer\n'

# Neovim
alias v="nvim"

# Turso
export PATH="/home/peti/.turso:$PATH"

# Go
export PATH=$PATH:/usr/local/go/bin
export GOPATH="$HOME/go"
export PATH=$GOPATH/bin:$PATH

# Environment
export BROWSER='google-chrome-stable'
export EDITOR='nvim'
export VISUAL='nvim'
export TERM='xterm-256color'

# bun completions
[ -s "/home/peti/.bun/_bun" ] && source "/home/peti/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
