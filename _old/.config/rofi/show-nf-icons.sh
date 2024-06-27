#/bin/bash

cat ~/.config/rofi/nf-icons.txt | rofi -dmenu -p "NF Cheatsheet" -columns 2 -width 40 | cut -d" " -f1 | tr '\n' ' ' | sed 's/⠀//g; s/\s//g' | xclip -selection clipboard
