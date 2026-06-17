#!/bin/bash

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages
brew tap homebrew/cask-fonts
brew tap cormacrelf/tap
brew install \
    stow \
    tmux \
    zsh \
    go \
    cmake \
    tree-sitter-cli \
    brave-browser \
    node \
    ghostty \
    lima \
    colima \
    bun-bin \
    opencode \
    dark-notify \
    1password-cli

# Remove
rm -rf ~/Projects/dots

# Clone
mkdir -p ~/Projects
cd Projects
git clone https://github.com/peterszarvas94/dots.git
git clone git@github.com:peterszarvas94/private.git
git clone https://github.com/peterszarvas94/omarchy-nvim-theme-grabber.git

# Origin
cd ~/Projects/dots
git remote remove origin 2>/dev/null || true
git remote add origin git@github.com:peterszarvas94/dots.git

mkdir -p ~/Work
mkdir -p ~/Projects/go
mkdir -p ~/youtube

# SSH config for 1Password
mkdir -p stow/ssh/.ssh
printf 'Host *\n\tIdentityAgent ~/.1password/agent.sock\n' > stow/ssh/.ssh/config

# Config packages
./config --pkg=all --font

# 1Password
echo ""
echo "Login to 1Password:"
echo "  op signin"
