# Cephi's dotfiles

My Arch Linux dotfiles.

---
# Cephi's Arch Linux Installation Steps

[Arch Linux Installation Guide](https://wiki.archlinux.org/title/Installation_guide)

## Installation Medium Setup

### Connect Installation Medium to Internet

To connect to the Internet, run
```
iwctl
```

> `<device>` and `<SSID>` are dependent on the device list and desired network.
```
device list
station <device> scan
station <device> get-networks
station <device> connect <SSID>
quit
```

Check that the connection is up by doing 
```
ping archlinux.org
```

### Update System Clock

```
timedatectl set-timezone "America/New_York"
```

Update keyring in case the ISO is out of date.
```
pacman -Sy archlinux-keyring
```

---

## Disk Partitioning and Formatting

```
fdisk -l
fdisk /dev/the_disk_to_be_partitioned
```

| Mount point | Partition | Partition Type | Size of Choice |
|-------------|-----------|----------------|----------------|
| /mnt/boot | /dev/*efi_system_partition* | EFI system partition (fdisk partition type 1) | 1GB |
| \[SWAP\] | /dev/*swap_partition* | Linux Swap (fdisk partition type 19) | Half of system RAM |
| /mnt | /dev/*root_partition* | Linux x86-64 root (fdisk partition type 23) | Remainder of the device |

```
mkfs.ext4 /dev/root_partition -L arch_os
mkswap /dev/swap_partition -L swap
mkfs.fat -F 32 /dev/efi_system_partition -n GRUB
```

```
mount /dev/root_partition /mnt
mount --mkdir /dev/efi_system_partition /mnt/boot
swapon /dev/swap_partition
```

---

## Arch Linux Installation

Don't forget to include nvidia drm for wayland compatibility

`pacstrap -K /mnt base linux linux-firmware`

`cp /etc/systemd/network/* /mnt/etc/systemd/network/`  LOL

`genfstab -U /mnt >> /mnt/etc/fstab`

`arch-chroot /mnt`

`pacman -Syu pacman-contrib vim networkmanager sudo ufw man-db man-pages texinfo wget w3m tmux speedtest-cli base-devel unzip openssh neofetch htop nvtop btop`

`pacman -Syu xclip` OR `pacman -Syu wl-clipboard` depending on X11 or Wayland

## Configuration

Change configuration files, like `/etc/pacman.conf` to add the multilib repo, enable parallel downloads, etc.

```
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
```

Edit `/etc/locale.gen` and uncomment `en_US.UTF-8 UTF-8` and other locales

```
locale-gen
```

Create `/etc/locale.conf` with `LANG=en_US.UTF-8` in it.

Create `/etc/hostname` with your hostname in it.

Create a password for root

```
passwd
```

---

## Bootloader Installation and Configuration

`pacman -Syu amd-ucode` or `pacman -Syu intel-ucode`

`pacman -Syu grub efibootmgr`

`pacman -Syu os-prober`  <- If windows needs to be dual-booted

```
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch
```

Edit `/etc/default/grub` to include `GRUB_DISABLE_OS_PROBER=false` <- If windows needs to be dual-booted

`grub-mkconfig -o /boot/grub/grub.cfg` <- If windows needs to be dual-booted, this will not capture Windows because arch-chroot does not allow direct access to disks. You will run this command once booted into the actual OS.

Don't forget to include nvidia drm for wayland compatibility if necessary

`exit`

---

Boot the system

`reboot`

`grub-mkconfig -o /boot/grub/grub.cfg` <- If windows needs to be dual-booted

`ufw enable`

---

Connect to Wi-Fi using

`systemctl enable --now ufw NetworkManager systemd-networkd systemd-resolved`

`systemctl enable --now NetworkManager`

`systemctl enable --now systemd-networkd`

`systemctl enable --now systemd-resolved` 

```
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

`nmcli d wifi list`

`nmcli d wifi connect <network> password <password>` 

---

Enable time synchronization

`systemctl enable --now systemd-timesyncd`

---

Configure the user

`useradd -G video,input -m <user>`

`passwd <user>`

Add user to sudoers

`EDITOR=vim visudo`

---

Switch to the user at this point

---

Dev Tools

`sudo pacman -Syu git rustup`

`rustup default stable`

rustup for cargo is better for dev.

---

AUR Helper (paru)

```
mkdir -p ~/Downloads/git && cd ~/Downloads/git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

---

mkinitcpio firmware

`paru -S mkinitcpio-firmware`

---

## Graphics

### AMD

`sudo pacman -Syu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon xf86-video-amdgpu libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau`

### Nvidia

Set up the Nvidia, mkinitcpio hook for pacman.

`sudo pacman -Syu nvidia nvidia-utils lib32-nvidia-utils nvidia-settings`

`reboot`

> Make sure that nvidia drivers are in use `lspci -k | grep -B 2 nvidia`

### Intel

`sudo pacman -Syu mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver`

---

## Desktop Setup

#### Refresh mirrors on a weekly basis:

`sudo pacman -Syu reflector && sudo systemctl enable reflector.timer` 

#### CPU Frequency:

`sudo pacman -Syu power-profiles-daemon python-gobject && sudo systemctl enable --now power-profiles-daemon` 

#### SSD Trimming:

`sudo systemctl enable fstrim.timer`

#### Audio:

> Automatically uses wireplumber now!!

`sudo pacman -Syu pipewire pipewire-jack pipewire-pulse pipewire-alsa` 

May require ALSA firmware extras, like `sof-firmware` .

#### Bluetooth:

`sudo pacman -Syu bluez bluez-utils && sudo systemctl enable --now bluetooth.service` 

#### Basic and graphical fonts:

`sudo pacman -Syu gnu-free-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra nerd-fonts ttf-font-awesome otf-font-awesome` 

`sudo mkdir -p /etc/fonts/conf.d/ && sudo ln -s /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf /etc/fonts/conf.d/` 

---

## Hyprland

### Feature Overview

Window management & hotkeys - Hyprland  
Display manager - SDDM  
Polkit - KDE  
Status bar w/ tray icons - Waybar  
App launcher - Fuzzel  
Notifications - swaync  
Onscreen Display - SwayOSD  
Screenshot - Grimblast (shell script) using grim, slurp, and hyprpicker  
Wallpaper - hyprpaper OR (swaybg/swww + waypaper)  
Lockscreen - swaylock (+ swayidle)

### Basic Applications

`sudo pacman -Syu firefox` 

- Terminal out-of-the-box: `sudo pacman -Syu kitty` 
- Terminal that requires editing `~/.config/hypr/hyprland.conf`: `sudo pacman -Syu alacritty`

### Window Manager and Display Manager

`sudo pacman -Syu hyprland sddm`

`sudo systemctl enable sddm` 

#### Fun DPI Display Fuckery

To get applications to scale properly:

- QT: Env variable `QT_SCALE_FACTOR` (float)
- GTK: Env variable `GDK_SCALE` (int)
- Electron: Add `--force-device-scale-factor=<float>` to the `.desktop` in  `/usr/share/applications/`  OR just use `ctrl++`
- XWayland: In `~/.config/hypr/hyprland.conf`

  ```
  xwayland {
      force_zero_scaling = true
  }
  ```

#### Necessary Packages

`sudo pacman -Syu xdg-desktop-portal-hyprland xdg-desktop-portal-gtk wev qt5-wayland qt6-wayland jq` 

`paru -S xwaylandvideobridge-bin` <- Screensharing shenanigans

Media control: `sudo pacman -Syu playerctl`

Brightness control: `sudo pacman -Syu brightnessctl`

Use `wev` ( `ctrl` + `c`  to exit ) to determine keycodes for `~/.config/hypr/hyprland.conf`

```
I know I'm from the future, but you need to remove SDL_VIDEODRIVER=wayland for the vast majority of Steam games to function 
```

### Policy Kit

`sudo pacman -Syu polkit-kde-agent` 

> `~/.config/hypr/hyprland.conf` 

```
exec-once=/usr/lib/polkit-kde-authentication-agent-1
```

### Screen Rotation (For tablet PCs)

`paru -S iio-hyprland` (this will automatically download iio-sensor-proxy as a dependency)

Run `hyprctl monitors` to obtain desired monitor for rotation.

> It may be necessary to specify the monitor in `~/.config/hypr/hyprland.conf` like so.
>
> ```
> monitor = $mainMoni,preferred,auto,auto
> ```

`~/.config/hypr/hyprland.conf`

```
exec-once = iio-sensor-proxy & iio-hyprland
```

### Swaylock

`sudo pacman -Syu swaylock`

Swaylock can be run with the following command:

`swaylock --daemonize --indicator-caps-lock --show-failed-attempts` 

This command will get called with the `fuzzel-power-menu` script (see below).

### Fuzzel (Application Launcher)

Fuzzel is a smaller, faster application launcher than Rofi, while still providing the base dmenu functionality necessary.

`sudo pacman -Syu fuzzel`

> `~/.config/hypr/hyprland.conf`

```
bindr = $mainMod, Super_L, exec, killall fuzzel || fuzzel
```

#### Clipboard History

See below.

#### Emoji Selector

Bemoji has history built-in and sends the emoji list via dmenu.  
It also allows for easily adding new entries like kaomoji :D

`sudo pacman -Syu bemoji`

> `~/.config/hypr/hyprland.conf` 

```
bind = $mainMod, 60, exec, killall fuzzel; BEMOJI_PICKER_CMD="fuzzel -d" bemoji -t # Super + .
```

#### Wifi Menu

A basic, custom-made nmcli frontend script stored in `~/.config/fuzzel/` using Material Design icons to match my Waybar.

#### Power Menu

 A script stored in `~/.config/fuzzel/` which makes use of `swaylock` (see below).

One fun way to call this menu is via the power button, so I modified `/etc/systemd/logind.conf` to ignore the power key, then

>  `~/.config/hypr/hyprland.conf`

```
bind = , XF86PowerOff, exec, ~/.config/fuzzel/fuzzel-power-menu
```

### Waybar (Status Bar)

`sudo pacman -Syu waybar` 

`cp -r /etc/xdg/waybar/ ~/.config/waybar/` 

#### Edit `config`

- Uncomment the layer top line so that waybar appears on top of windows
- Remove/add desired modules
- Replace "sway" with "hyprland"
- Change "focused" to "active" when referring to workspaces
- <<https://www.reddit.com/r/hyprland/comments/12gn52e/comment/jfofgv4/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button>\> Monitor-independent workspaces idea which is turned into a script for my dotfiles.

### Clipboard

`sudo pacman -Syu cliphist`

>  `~/.config/hypr/hyprland.conf`

```ini
exec-once = wl-paste --type text --watch cliphist store #Stores only text data

exec-once = wl-paste --type image --watch cliphist store #Stores only image data
```

```
bind = $mainMod, V, exec, killall fuzzel; cliphist list | fuzzel -d | cliphist decode | wl-copy
```

### Screenshotting

For screenshots, the grimblast script will freeze the screen using hyprpicker, select a region using slurp, and screenshot using grim.

`paru -S grim slurp hyprpicker` 

Pull this repo <[https://github.com/hyprwm/contrib/](https://github.com/hyprwm/contrib/tree/main)\> and run `make install`

`~/.config/hypr/hyprland.conf`

```
bind = $mainMod, SHIFT, S, exec, grimblast --freeze copy area
bind = , 107, exec, grimblast copy screen # Prt Sc
bind = $mainMod, 107, exec, grimbast copy active # Super + Prt Sc
```

### Notifications

`paru -S swaync` 

```
exec-once = swaync
```

```
bind = $mainMod, N, exec, swaync-client -t -sw
```

### Wallpaper

- Static: `sudo pacman -Syu hyprpaper` 
- Animated: `paru -S swww waypaper-git`

### Default Applications

`sudo pacman -Syu perl-file-mimeinfo` 

Set default application for given filetype:

`mimeopen -d <filename>.<filetype>`

### Aesthetics

#### Font

FiraMono Nerd Font

FiraMono Nerd Font Mono and FiraMono Nerd Font Propo are used as needed.

FiraCode is not used to avoid having to deal with ligatures.

#### Hyprland

<<https://github.com/catppuccin/hyprland>\>

#### SDDM

<<https://github.com/Kangie/sddm-sugar-candy>\>

`sudo pacman -S --needed sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg` 

`git clone https://github.com/Kangie/sddm-sugar-candy && cd sddm-sugar-candy` 

`sudo mkdir /usr/share/sddm/themes/sugar-candy && sudo cp -r . /usr/share/sddm/themes/sugar-candy` 

`sudo cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf` 

> `/etc/sddm.conf` 

```
[Theme]
Current=sugar-candy
```

#### Swaylock

<<https://github.com/catppuccin/swaylock>\>

#### Alacritty

<<https://github.com/catppuccin/alacritty>\>

#### Fuzzel

<<https://github.com/catppuccin/fuzzel>\>

#### Waybar

<<https://github.com/catppuccin/waybar>\>

#### SwayNC

<<https://github.com/catppuccin/swaync>\>

#### Qt & GTK

<<https://wiki.archlinux.org/title/Uniform_look_for_Qt_and_GTK_applications>\>

##### Qt

`sudo pacman -Syu qt5ct kvantum` 

<<https://github.com/catppuccin/Kvantum>\>

> `~/.config/hypr/hyprland.conf`

```
env = QT_QPA_PLATFORMTHEME,qt5ct
```

Using qt5ct, set the style to kvantum.

Using kvantum, set the theme to Catppuccin and enable transparency as necessary.

**NOTE**: Kvantum uses "reduction in opacity" rather than just "opacity", so if the desired opacity is 70%, use 30%.

##### GTK

`sudo pacman -Syu gnome-themes-extra`

`paru -S catppuccin-gtk-theme-mocha catppuccin-gtk-theme-macchiato catppuccin-gtk-theme-frappe catppuccin-gtk-theme-latte` 

```
env = GTK_THEME,Catppuccin-Macchiato-Standard-Lavender-Dark:dark
env = GTK2_RC_FILES,/usr/share/themes/Catppuccin-Macchiato-Standard-Lavender-Dark/gtk-2.0/gtkrc
```

#### Icons

`sudo pacman -S papirus-icon-theme` 

`paru -S papirus-folders-catppuccin-git && papirus-folders -h` 

### Applications

Dolphin (File Browser): `sudo pacman -Syu dolphin dolphin-plugins kdegraphics-thumbnailers libheif qt5-imageformats kdesdk-thumbnailers ffmpegthumbs taglib kompare ark`

Pavucontrol (Audio Device Control): `sudo pacman -Syu pavucontrol` 

### Wallpaper

<<https://www.artstation.com/artwork/4Xa124>\>

GNOME TIME

  
PLASMA ONLY

`sudo pacman -Syu plasma plasma-wayland-session sddm && sudo systemctl enable sddm`

`sudo pacman -Syu dolphin-plugins ffmpegthumbs kde-inotify-survey kdeconnect kdegraphics-thumbnailers kdenetwork-filesharing kio-admin print-manager`

> It's going to ask for a few options, basically pick pipewire-jack, wireplumber, and vlc. 

PLASMA CUSTOMIZATION

bismuth for tiling

Minimal desktop indicator

Better inline clock

papirus icons

geometry change effect

force blur maybe

kvantum

catppuccin and glassy (maybe layan? layan's logout buttons were a bit odd)

catppuccin-grub

catppuccin-sddm

catppuccin-kde

catppuccin-kvantum

`sudo pacman -Syu papirus-icon-theme`

catppuccin-konsole

catppuccin-discord + `paru -S beautifuldiscord`

Utterly Round

NEW CUSTOMIZATION GUIDE

catppuccin-kde (git) install everything, make sure to icon symlink

set preferred cursor, logout login

kvantum, use kvantum-dark for application style

Utterly Round plasma style (store) and kvantum (git) (I have a fork for kvantum to fix the script)

`paru -S papirus-folders-catppuccin-git && papirus-folders -h` 

`paru -S kwin-bismuth-bin` for window tiling. Customize as necessary

Keybinds:

Switch Desktops: Meta+1 - Meta+0

Move Window to Desktop: Meta+Shift+1 - Meta+Shift+0

Switch Window Focus (Use Kwin bc Bismuth doesn't go across monitors): Meta+dir

Move Window (Use Bismuth): Meta+Shift+dir

Resize Window: Meta+Alt+dir

---

  
Applications

`sudo pacman -Syu konsole dolphin ark kate firefox`

`sudo pacman -Syu iio-sensor-proxy maliit-keyboard anthy` <- laptop rotation and on-screen keyboard (anthy is for japanese)

> You can restart into the GUI now

KDE Graphics

`sudo pacman -Syu okular gwenview spectacle kolourpaint kcolorchooser krita`

`sudo pacman -Syu kcalc partitionmanager`

`sudo pacman -Syu discord steam`

`sudo pacman -Syu nextcloud-client kio5` kio5 for dolphin

---

## Firefox Customization

<<https://github.com/yokoffing/Betterfox>\>  
Improving the Firefox experience

<<https://github.com/migueravila/SimpleFox>\>  
Improving the Firefox look and feel

<<https://github.com/guest271314/no-copilot-ad>\>  
Getting ride of that stupid copilot ad in github

Can make things simple by placing this in `...default-release/chrome/userContent.css` 

```css
@-moz-document domain(github.com) {
    .react-code-size-details-in-header:nth-of-type(2),[data-testid="copilot-popover-button"]{display:none!important}
}
```

Customization

Touchpad gestures:

Firefox

> Requires MOZ_USE_XINPUT=1, MOZ_ENABLE_WAYLAND=1, and possibly GDK_BACKEND=wayland
>
> This can be tested by doing `MOZ_USE_XINPUT=1 MOZ_ENABLE_WAYLAND=1 firefox`
>
> If it works, export these variables in your `~/.bashrc` like `export MOZ_USE_XINPUT=1`

Shortcuts:

Screenshots

> This no work on Wayland >:(

```
maim -s | xclip -selection clipboard -t image/png
```

<https://github.com/catppuccin/catppuccin>

I like macchiato on laptop, frappe or mocha on desktop :D

<https://github.com/MeledoJames/awesome-setup>

Firefox Hardening (Security & removal of telemetry)

<https://github.com/yokoffing/Betterfox>

<https://github.com/migueravila/SimpleFox>

# Graveyard

### Rofi (Application Launcher)

The application launcher and Super key hero of this rice, which will have much easy-to-access functionality built-in

- For the original rofi, which will suffer xwayland DPI fuckery: `sudo pacman -Syu rofi` 
- For a Wayland port, which may lose support one day:  `paru -S rofi-lbonn-wayland` 

> `~/.config/hypr/hyprland.conf` 

```
bindr = $mainMod, Super_L, exec, killall rofi || rofi -show drun -show-icons
```

The bindr and killall are so that rofi can easily be closed with the Super key.

This rofi config will now allow application launching. I want more features sooo

#### Emoji Selector

`sudo pacman -Syu rofi-emoji wtype`  ~~<- wtype is an optional dependency that should probably be actually marked as such...~~

~~<[https://github.com/Mange/rofi-emoji](https://github.com/Mange/rofi-emoji)\>~~

~~The GitHub page has more information regarding custom emoji databases (like for kaomoji)~~

`sudo pacman -Syu rofimoji wtype`

<[https://github.com/fdw/rofimoji](https://github.com/fdw/rofimoji#actions)\>

Rofimoji is a great emoji selector that automatically goes through Rofi, has up to 10 emojis of history, and is easily called through `rofimoji` 

If you want rofimoji to do multiple things on `return` , then actions can be specified like so:

`rofimoji -a type copy` <- This will type the selected emoji and copy it into the clipboard.

#### Calculator

`sudo pacman -Syu rofi-calc` 

<<https://github.com/svenstaro/rofi-calc>\>

`rofi -show calc -modi calc -no-show-match -no-sort -automatic-save-to-history` 

THIS IS NOT VERY EASY TO USE. PYTHON IT IS.

#### Power Menu

This power menu from Eric Murphy is a very basic, reproducible script. Just make modifications to the commands called as necessary.

<<https://github.com/ericmurphyxyz/dotfiles/blob/master/.local/bin/powermenu>\>

One fun way to call this menu is via the power button, so I modified `/etc/systemd/logind.conf` to ignore the power key, then

>  `~/.config/hypr/hyprland.conf`

```
bind = , XF86PowerOff, exec, ~/.config/rofi/rofi-power-menu
```

### 
