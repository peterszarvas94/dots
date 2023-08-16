export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/home/peti/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# github ssh
if [[ -o interactive ]]; then
    export PATH="$HOME/.local/lib:$PATH"
    eval "$(keychain --eval --agents ssh --quiet --inherit any --quick ~/.ssh/github)"
fi

# Control+F
bindkey -s '^F' 'tmux-sessionizer\n'

alias v="nvim"

# Turso
export PATH="/home/peti/.turso:$PATH"

export BROWSER=brave
export EDITOR='nvim'
export VISUAL='nvim'
