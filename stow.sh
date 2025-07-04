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
COMMON="scripts tmux zsh alacritty git nvim opencode zed ghostty aerc"

# Only run if platform is specified
if [[ "$PLATFORM" == "mac" ]]; then
    stow --dir=stow --target=$HOME $COMMON zsh-mac aerospace
elif [[ "$PLATFORM" == "arch" ]]; then
    stow --dir=stow --target=$HOME $COMMON hypr waybar
else
    echo "run with -mac or -arch flag"
fi
