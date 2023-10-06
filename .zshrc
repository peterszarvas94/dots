# zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# scripts
export PATH="$HOME/.local/bin:$PATH"

# github ssh
if [[ -o interactive ]]; then
    eval "$(keychain --eval --agents ssh --quiet --inherit any --quick ~/.ssh/github)"
fi

# Control+F to open tmux-sessionizer
bindkey -s '^F' 'tmux-sessionizer\n'

# Neovim
alias v="nvim"

# Turso
export PATH="/home/peti/.turso:$PATH"

# Go
export GOPATH="$HOME/go"

# Environment
export BROWSER=brave
export EDITOR='nvim'
export VISUAL='nvim'
export TERM='xterm-256color'
