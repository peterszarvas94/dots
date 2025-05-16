# Enable vi mode
bindkey -v '^?' backward-delete-char
export KEYTIMEOUT=1
# for bash:
# set -o vi

# disable flow control, so I can remap ctrl-s and ctrl-q
stty -ixon
# bindkey '^R' history-incremental-search-backward
# bindkey '^S' history-incremental-search-forward

fzf-history-search-backward() {
  local initial_query="$BUFFER"
  BUFFER=$(history -r 1 | awk '{$1=""; print substr($0, 2)}' | awk '!seen[$0]++' | fzf --query="$initial_query")
  CURSOR=$#BUFFER
}
zle -N fzf-history-search-backward
bindkey '^R' fzf-history-search-backward

fzf-history-search-forward() {
  local initial_query="$BUFFER"
  BUFFER=$(history -r 1 | tac | awk '{$1=""; print substr($0, 2)}' | awk '!seen[$0]++' | fzf --query="$initial_query")
  CURSOR=$#BUFFER
}
zle -N fzf-history-search-forward
bindkey '^S' fzf-history-search-forward

bindkey -M vicmd -r j
bindkey -M vicmd -r k
bindkey -M vicmd '^N' down-line-or-history
bindkey -M vicmd '^P' up-line-or-history

# tmux-sessionizer
# bindkey -s '^F' 'ts\n'

zle -N reload-zsh
# bindkey -s '^Z' 'zsh\n'
