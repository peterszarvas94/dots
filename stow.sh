#!/bin/bash

DOTFILES_DIR=~/projects/dots/stow

cd $DOTFILES_DIR

for dir in */; do
  stow --dir $DOTFILES_DIR --target=$HOME --adopt "$dir"
done
