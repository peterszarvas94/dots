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

# control+f to open tmux-sessionizer
bindkey -s '^F' 'tmux-sessionizer\n'

# neovim
alias v="nvim"

# turso
export PATH="/home/peti/.turso:$PATH"

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

# bun completions
[ -s "/home/peti/.bun/_bun" ] && source "/home/peti/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
