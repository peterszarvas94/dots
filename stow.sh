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
        *)
            break
            ;;
    esac
done

# Common packages for all platforms
COMMON="scripts tmux zsh aerospace alacritty git nvim opencode starship zed ghostty aerc"

# Only run if platform is specified
if [[ "$PLATFORM" == "mac" ]]; then
    stow --dir=stow --target=$HOME $COMMON skhd yabai amethyst karabiner
elif [[ "$PLATFORM" == "arch" ]]; then
    stow --dir=stow --target=$HOME $COMMON hypr waybar
else
    echo "run with -mac or -arch flag"
fi
