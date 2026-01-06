# Change cursor shape for different vi modes
# function zle-keymap-select {
#   if [[ ${KEYMAP} == vicmd ]] ||
#      [[ $1 = 'block' ]]; then
#     echo -ne '\e[2 q' # Block cursor, "/e[1 q is blinking"
#   elif [[ ${KEYMAP} == main ]] ||
#        [[ ${KEYMAP} == viins ]] ||
#        [[ ${KEYMAP} = '' ]] ||
#        [[ $1 = 'beam' ]]; then
#     echo -ne '\e[6 q' # Beam cursor "/e[5 q is blinking
#   fi
# }
# zle -N zle-keymap-select
#
# # Initial cursor shape
# echo -ne '\e[6 q'
#
# # Reset cursor when starting new terminal
# function zle-line-init() {
#     echo -ne '\e[6 q'
# }
# zle -N zle-line-init
