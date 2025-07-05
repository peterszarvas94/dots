#!/bin/bash

# Parse arguments
PLATFORM=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -mac)
            PLATFORM="mac"
            shift
            ;;
        -arch)
            PLATFORM="arch"
            shift
            ;;
        -ubuntu)
            PLATFORM="arch"
            shift
            ;;
        *)
            break
            ;;
    esac
done

# Only run if platform is specified
if [[ "$PLATFORM" == "mac" ]]; then
    # mac stuff
    rm -rf ~/.config/aerospace
    stow --dir=stow --target=$HOME aerospace

    # common
    rm -rf ~/.config/.gitignore
    rm -rf ~/.config/git
    stow --dir=stow --target=$HOME git

    rm -rf ~/.config/.zshrc
    rm -rf ~/.config/zsh
    touch stow/zsh/.zsh/config/env.zsh
    stow --dir=stow --target=$HOME zsh 
    stow --dir=stow --target=$HOME zsh-mac

    rm -rf ~/.config/nvim
    stow --dir=stow --target=$HOME nvim

    rm -rf ~/.config/opencode
    stow --dir=stow --target=$HOME opencode 

    rm -rf ~/.local/bin
    stow --dir=stow --target=$HOME scripts

    rm -rf ~/.config/alacritty
    stow --dir=stow --target=$HOME alacritty

    rm -rf ~/.config/.tmux.conf
    rm -rf ~/.config/tmux
    stow --dir=stow --target=$HOME tmux
elif [[ "$PLATFORM" == "arch" ]]; then
    # arch stuff
    rm -rf ~/.config/hypr
    stow --dir=stow --target=$HOME $COMMON hypr

    rm -rf ~/.config/waybar
    stow --dir=stow --target=$HOME $COMMON waybar

    # common
    rm -rf ~/.config/.gitignore
    rm -rf ~/.config/git
    stow --dir=stow --target=$HOME git

    rm -rf ~/.config/.zshrc
    rm -rf ~/.config/zsh
    touch stow/zsh/.zsh/config/env.zsh
    stow --dir=stow --target=$HOME zsh 
    stow --dir=stow --target=$HOME zsh-arch

    rm -rf ~/.config/nvim
    stow --dir=stow --target=$HOME nvim

    rm -rf ~/.config/opencode
    stow --dir=stow --target=$HOME opencode 

    rm -rf ~/.local/bin
    stow --dir=stow --target=$HOME scripts

    rm -rf ~/.config/alacritty
    stow --dir=stow --target=$HOME alacritty

    rm -rf ~/.config/.tmux.conf
    rm -rf ~/.config/tmux
    stow --dir=stow --target=$HOME tmux
elif [[ "$PLATFORM" == "ubunutu" ]]; then
    echo ""
else
    echo "run with -mac, -arch or -ubuntu flag"
fi
