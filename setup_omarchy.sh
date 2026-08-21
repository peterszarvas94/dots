#!/bin/bash

# This thing
sudo pacman -S --needed base-devel

# Install packages
yay -S --noconfirm --needed \
    stow \
    fzf \
    zsh \
    go \
    cmake \
    tree-sitter \
    brave-browser \
    nvm \
    ghostty \
    qemu-base \
    lima-bin \
    colima-bin \
    bun-bin \
    opencode \
    1password-cli \
    github-cli

zsh_path="$(command -v zsh)"
current_shell="$(getent passwd "$USER" | cut -d: -f7)"
if [[ "$current_shell" != "$zsh_path" ]]; then
    echo "Changing login shell to $zsh_path"
    chsh -s "$zsh_path"
fi

# Remove
rm -rf ~/Projects/dots

# Clone
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/peterszarvas94/dots.git

# Origin
cd ~/Projects/dots
git remote remove origin 2>/dev/null || true
git remote add origin git@github.com:peterszarvas94/dots.git


mkdir -p ~/Work
mkdir -p ~/Projects/go
mkdir -p ~/youtube

./config.sh --pkg=all --debloat

# 1Password
echo ""
echo "Login to 1Password:"
echo "  op signin"
