#! /bin/bash

git submodule init
git submodule update

# Stow Dotfiles
mkdir -p ~/.config
mkdir -p ~/.local/share
mv -v ~/.bashrc ~/.bashrc.bak
stow -v .
rm -v ~/.bashrc.bak

# AUR Helper
makepkg -siD git/paru-bin
bash -c 'cd git/paru-bin && git clean -df'

# CLI Applications
sudo pacman -Syu --needed pacman-contrib base-devel
sudo pacman -Syu --needed man-db man-pages texinfo
sudo pacman -Syu --needed wget curl unzip openssh nmap openbsd-netcat
sudo pacman -Syu --needed btop htop nvtop speedtest-cli

# Audio
sudo pacman -Syu --needed pipewire pipewire-audio pipewire-jack pipewire-pulse wireplumber pulsemixer

# Fonts
sudo pacman -Syu --needed gnu-free-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra nerd-fonts

# GUI Applications
sudo pacman -Syu --needed alacritty firefox mpv

# Firefox Setup
firefox --headless --screenshot /dev/null > /dev/null
ln -v git/BetterFox/user.js ~/.mozilla/firefox/*.default-release/.

# GNOME
sudo pacman -Syu --needed gnome gnome-tweaks gnome-browser-connector dconf-editor file-roller

echo "Configuring GNOME..."
echo "Removing close button..."
gsettings set org.gnome.desktop.wm.preferences button-layout appmenu
echo "Disabling bell..."
gsettings set org.gnome.Console audible-bell false
echo "Setting keybinds..."
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>i']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>z']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super><Shift>s']"
gsettings set org.gnome.shell.keybindings screenshot "['Print']"
gsettings set org.gnome.shell.keybindings screenshot-window "['<Super>Print']"

echo "Enabling extensions..."
gnome-extensions enable status-icons@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable drive-menu@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable launch-new-instance@gnome-shell-extensions.gcampax.github.com

# Hyprland
sudo pacman -Syu --needed hyprland hyprpolkitagent hyprlock hyprpicker
sudo pacman -Syu --needed jq playerctl brightnessctl
sudo pacman -Syu --needed hyprpicker grim slurp
sudo pacman -Syu --needed fuzzel cliphist
paru -S bemoji
bash -c 'cd git/hyprwm-contrib/grimblast && sudo make install'
