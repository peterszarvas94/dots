#!/bin/bash

mkdir -p ~/projects/dots

git clone https://github.com/peterszarvas94/dots ~/projects/dots
cd projects/dots

sudo pacman -S --needed base-devel

# Check if paru is installed
if ! command -v paru &> /dev/null; then
    echo "Installing paru..."
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ..
    rm -rf paru
else
    echo "paru is already installed"
fi

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
