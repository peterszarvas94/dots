#!/bin/bash

# This thing
sudo pacman -S --needed base-devel

# Install packages
yay -S --noconfirm --needed \
    stow \
    tmux \
    zsh \
    go \
    cmake \
    brave-browser \
    nodejs \
    ghostty \
    qemu-base \
    lima-bin \
    colima-bin \
    bun-bin \
    opencode \
    1password-cli

# Remove
rm -rf ~/Projects/dots
rm -rf ~/Projects/LazyVim

# Clone
mkdir -p ~/Projects
cd Projects
git clone https://github.com/peterszarvas94/dots.git
git clone https://github.com/peterszarvas94/omarchy-nvim-theme-grabber.git LazyVim

# Origin
cd ~/Projects/LazyVim
git remote remove origin 2>/dev/null || true
git remote add origin git@github.com:peterszarvas94/omarchy-nvim-theme-grabber.git
cd ~/Projects/dots
git remote remove origin 2>/dev/null || true
git remote add origin git@github.com:peterszarvas94/dots.git


mkdir -p ~/Work
mkdir -p ~/Projects/go
mkdir -p ~/youtube

# SSH config for 1Password
mkdir -p stow/ssh/.ssh
printf 'Host *\n\tIdentityAgent ~/.1password/agent.sock\n' > stow/ssh/.ssh/config

# Clone private repo for fonts
git clone git@github.com:peterszarvas94/private.git ~/Projects/private 2>/dev/null || true

# Install rose-pine-dark theme
omarchy-theme-install https://github.com/guilhermetk/omarchy-rose-pine-dark.git

./config --pkg=all --font --debloat

# 1Password
echo ""
echo "Login to 1Password:"
echo "  op signin"
