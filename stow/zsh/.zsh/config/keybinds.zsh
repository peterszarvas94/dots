# Enable vi mode
bindkey -v '^?' backward-delete-char
export KEYTIMEOUT=1
# for bash:
# set -o vi

# disable flow control, so I can remap ctrl-s and ctrl-q
stty -ixon

bindkey -M vicmd -r j
bindkey -M vicmd -r k
bindkey -M vicmd '^N' down-line-or-history
bindkey -M vicmd '^P' up-line-or-history
# bindkey '^R' history-incremental-search-backward
# bindkey '^S' history-incremental-search-forward

# fzf history
fzf-history-search-backward() {
BUFFER=$(history -r 1 | awk '{$1=""; print substr($0, 2)}' | fzf)
  CURSOR=$#BUFFER
}
zle -N fzf-history-search-backward
bindkey '^R' fzf-history-search-backward

fzf-history-search-forward() {
BUFFER=$(history -r 1 | tac | awk '{$1=""; print substr($0, 2)}' | fzf)
  CURSOR=$#BUFFER
}
zle -N fzf-history-search-forward
bindkey '^S' fzf-history-search-forward

# tmux-sessionizer
bindkey -s '^F' 'ts\n'

zle -N reload-zsh
bindkey -s '^Z' 'zsh\n'
