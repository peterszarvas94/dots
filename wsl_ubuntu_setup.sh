#!/usr/bin/env bash

# install packages
sudo apt update
sudo apt upgrade
sudo apt git 
sudo apt install build-essential 
sudo apt install unzip 
sudo apt install fzf 
sudo apt install ripgrep
sudo apt install xclip

# hide welcome message
sudo touch /root/.hushlogin

# cmake
cd ~/Downloads
wget https://github.com/Kitware/CMake/releases/download/v3.29.0-rc2/cmake-3.29.0-rc2-linux-x86_64.tar.gz
tar xzvf cmake-3.29.0-rc2-linux-x86_64.tar.gz
sudo mv ~/Downloads/cmake-3.29.0-rc2-linux-x86_64 /usr/lib/
for file in /usr/lib/cmake-3.29.0-rc2-linux-x86_64/bin/*; do sudo ln -s "$file" /usr/bin; done
rm -rf ~/Downloads/*

# go
cd ~/Downloads
wget https://golang.org/dl/go1.22.0.linux-amd64.tar.gz
tar xzvf go1.22.0.linux-amd64.tar.gz
sudo mv ~/Downloads/go /usr/lib
sudo ln -s /usr/lib/go/bin/go /usr/bin
rm -rf ~/Downloads/*

# clone dots
mkdir ~/projects
cd ~/projects
git clone https://github.com/peterszarvas94/dots
cd ~/projects/dots
git remote remove origin
git remote add origin git@github.com:peterszarvas94/dots.git

# set up neovim
mkdir -p ~/Downloads
cd ~/Downloads
wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
sudo mv ~/Downloads/nvim-linux64 /usr/lib/
sudo ln -s /usr/lib/nvim-linux64/bin/nvim /usr/bin/nvim
rm -rf ~/Downloads/*
mkdir -p ~/.config
ln -s ~/projects/dots/.config/nvim ~/.config/nvim

# gitconfig
rm -rf ~/.gitconfig
ln -s ~/projects/dots/.gitconfig.personal ~/.gitconfig
# ln -s ~/projects/dots/.gitconfig.work ~/.gitconfig

# gitignore
rm -rf ~/.gitignore
ln -s ~/projects/dots/.gitignore ~/.gitignore

# tmux
sudo apt install tmux
rm -rf ~/.tmux.conf
ln -s ~/projects/dots/.tmux.conf ~/.tmux.conf

# scripts
mkdir -p ~/.local/bin
ln -s ~/projects/dots/.local/bin/get-keycode ~/.local/bin/get-keycode
ln -s ~/projects/dots/.local/bin/killport ~/.local/bin/killport
ln -s ~/projects/dots/.local/bin/light ~/.local/bin/light
ln -s ~/projects/dots/.local/bin/stopwatch ~/.local/bin/stopwatch
ln -s ~/projects/dots/.local/bin/tmux-sessionizer ~/.local/bin/tmux-sessionizer

# ssh
mkdir -p ~/.ssh
cd ~/.ssh
echo "github" | ssh-keygen -t ed25519 -C "contact@peterszarvas.hu"
cat ~/.ssh/github.pub | xclip -selection clipboard
cmd.exe /c start chrome https://github.com/settings/ssh/new

# nvm, node, npm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
. ~/.nvm/nvm.sh
nvm install node

# tailwind cli
npm i -g tailwindcss

# set up zsh
cd ~
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc
ln -s ~/projects/dots/.zshrc ~/.zshrc
