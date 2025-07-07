#!/bin/bash

echo "Installing arch packages"

# echo "Installing paru"
# sudo pacman -S --needed base-devel
# git clone https://aur.archlinux.org/paru.git
# cd paru
# makepkg -si

# rm -rf paru

# paru -S --noconfirm --needed nvim alacritty stow tmux zsh nvm go extra/ttf-jetbrains-mono-nerd brave-browser
# source /usr/share/nvm/nvm.sh
# nvm install node
# nvm use node

mkdir -p ~/projects/dots

git clone https://github.com/peterszarvas94/dots projects/dots
cd projects/dots
