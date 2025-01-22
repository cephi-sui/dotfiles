#! /bin/bash

git submodule init
git submodule update

# CLI Applications
sudo pacman -Syu --needed pacman-contrib base-devel man-db man-pages texinfo
sudo pacman -Syu --needed wget curl unzip openssh
sudo pacman -Syu --needed btop htop nvtop speedtest-cli

# GUI Applications
sudo pacman -Syu --needed pipewire pipewire-audio pipewire-jack pipewire-pulse wireplumber
sudo pacman -Syu --needed gnu-free-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra nerd-fonts

# Set Up Firefox
sudo pacman -Syu --needed firefox 
firefox --headless --screenshot /dev/null > /dev/null
ln -v git/BetterFox/user.js ~/.mozilla/firefox/*.default-release/.

# Stow Dotfiles
mkdir -p ~/.config
mkdir -p ~/.local/share
mv -v ~/.bashrc ~/.bashrc.bak
stow -v .
rm -v ~/.bashrc.bak

# GNOME
sudo pacman -Syu gnome gnome-tweaks dconf-editor file-roller
