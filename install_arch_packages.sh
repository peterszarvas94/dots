#!/bin/bash

echo "Installing arch packages"

# echo "Installing paru"
# sudo pacman -S --needed base-devel
# git clone https://aur.archlinux.org/paru.git
# cd paru
# makepkg -si

# rm -rf paru

paru -S --noconfirm nvim alacritty stow tmux zsh nvm go extra/ttf-jetbrains-mono-nerd brave-browser
nvm install node
nvm use node
