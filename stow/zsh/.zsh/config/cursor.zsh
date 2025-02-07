# Enable vi mode
bindkey -v
export KEYTIMEOUT=1
# for bash:
# set -o vi

# Change cursor shape for different vi modes
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q' # Block cursor
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q' # Beam cursor
  fi
}
zle -N zle-keymap-select

# Initial cursor shape
echo -ne '\e[6 q'

# Reset cursor when starting new terminal
function zle-line-init() {
    echo -ne '\e[6 q'
}
zle -N zle-line-init
