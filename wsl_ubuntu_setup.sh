#!/usr/bin/env bash

# install packages
sudo apt update -y
sudo apt upgrade -y 
sudo apt install -y git
sudo apt install -y build-essential 
sudo apt install -y unzip 
sudo apt install -y fzf 
sudo apt install -y ripgrep
sudo apt install -y xclip

# hide welcome message
sudo touch /root/.hushlogin

# cmake
mkdir -p ~/Downloads
cd ~/Downloads
wget https://github.com/Kitware/CMake/releases/download/v3.29.0-rc2/cmake-3.29.0-rc2-linux-x86_64.tar.gz
tar xzvf cmake-3.29.0-rc2-linux-x86_64.tar.gz
sudo mv ~/Downloads/cmake-3.29.0-rc2-linux-x86_64 /usr/lib/
sudo ln -s /usr/lib/cmake-3.29.0-rc2-linux-x86_64/bin/ccmake /usr/bin
sudo ln -s /usr/lib/cmake-3.29.0-rc2-linux-x86_64/bin/cmake /usr/bin
sudo ln -s /usr/lib/cmake-3.29.0-rc2-linux-x86_64/bin/cmake-gui /usr/bin
sudo ln -s /usr/lib/cmake-3.29.0-rc2-linux-x86_64/bin/cpack /usr/bin
sudo ln -s /usr/lib/cmake-3.29.0-rc2-linux-x86_64/bin/ctest /usr/bin

# go
cd ~/Downloads
wget https://golang.org/dl/go1.22.0.linux-amd64.tar.gz
tar xzvf go1.22.0.linux-amd64.tar.gz
sudo mv ~/Downloads/go /usr/lib
sudo ln -s /usr/lib/go/bin/go /usr/bin

# clone dots
mkdir ~/projects
cd ~/projects
git clone https://github.com/peterszarvas94/dots
cd ~/projects/dots
git remote remove origin
git remote add origin git@github.com:peterszarvas94/dots.git

# neovim
cd ~/Downloads
wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
sudo mv ~/Downloads/nvim-linux64 /usr/lib/
sudo ln -s /usr/lib/nvim-linux64/bin/nvim /usr/bin/nvim
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
sudo apt install -y tmux
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
ln -s ~/projects/dots/.ssh/known_hosts ~/.ssh/known_hosts
echo "github" | ssh-keygen -t ed25519 -C "contact@peterszarvas.hu"
cat ~/.ssh/github.pub | xclip -selection clipboard
cd /mnt/c/Program\ Files/Google/Chrome/Application
./chrome.exe https://github.com/settings/ssh/new

# nvm, node, npm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
. ~/.nvm/nvm.sh
nvm install node

# tailwind cli
npm i -g tailwindcss

# zsh
cd ~
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended
rm -rf ~/.zshrc
ln -s ~/projects/dots/.zshrc ~/.zshrc
sudo chsh -s /bin/zsh peti
sudo rm -rf ~/Downloads/*
exec zsh
