#!/bin/bash

mkdir -p ~/projects/dots

git clone https://github.com/peterszarvas94/dots ~/projects/dots
cd projects/dots

sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git

cd paru
makepkg -si

cd ..
rm -rf paru

paru -S --noconfirm --needed \
    nvim \
    alacritty \
    stow \
    tmux \
    zsh \
    go \
    extra/ttf-jetbrains-mono-nerd \
    brave-browser \
    nodejs

yes | ./stow.sh --arch
