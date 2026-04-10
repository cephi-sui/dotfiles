#! /bin/bash

sudo systemctl start reflector

sudo pacman -Syu --needed stow
git submodule init
git submodule update

# Stow Dotfiles
mkdir -p ~/.config
mkdir -p ~/.local/share
mv -v ~/.bashrc ~/.bashrc.bak
stow -v .
rm -v ~/.bashrc.bak

# CLI Applications
sudo pacman -Syu --needed pacman-contrib base-devel
sudo pacman -Syu --needed man-db man-pages texinfo
sudo pacman -Syu --needed wget curl unzip openssh nmap openbsd-netcat
sudo pacman -Syu --needed btop htop nvtop speedtest-cli

# AUR Helper
sudo pacman -Syu --needed rustup
rustup default stable
makepkg -siD git/paru
bash -c 'cd git/paru && git clean -df'

# Audio
sudo pacman -Syu --needed pipewire pipewire-audio pipewire-jack pipewire-pulse wireplumber pulsemixer

# Audio Input Processing
sudo pacman -Syu --needed easyeffects lsp-plugins qtractor rnnoise calf
paru -Sua libdeep_filter_ladspa-git

# Bluetooth
sudo pacman -Syu --needed bluetui

# Fonts
sudo pacman -Syu --needed gnu-free-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra nerd-fonts

# IMF for typing in other languages
sudo pacman -Syu --needed fcitx5

# GUI Applications
sudo pacman -Syu --needed alacritty mpv firefox chromium

# Firefox Setup
xdg-settings set default-web-browser firefox.desktop
#firefox --headless --screenshot /dev/null > /dev/null
firefox --headless &
pid=$!
sleep 1s
kill $pid
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
#sudo pacman -Syu --needed hyprland hyprpolkitagent hyprlock hyprpicker hyprpaper
#sudo pacman -Syu --needed jq playerctl brightnessctl
#sudo pacman -Syu --needed fuzzel cliphist dunst
#paru -S bemoji waypaper bibata-cursor-theme-bin
#
#sudo pacman -Syu --needed hyprpicker grim slurp scdoc
#bash -c 'cd git/hyprwm-contrib/grimblast && sudo make install'
#
#sudo pacman -Syu --needed waybar

# Niri
sudo pacman -Syu --needed niri
#sudo pacman -Syu mako swaybg swaylock
sudo pacman -Syu --needed polkit-kde-agent xwayland-satellite
sudo pacman -Syu --needed xdg-desktop-portal-gtk xdg-desktop-port-gnome gnome-keyring

sudo systemctl enable --now gdm
