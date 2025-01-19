## Notes
### GTK Theming
Set theme to dark in settings and adw-gtk3-dark in tweaks

### GNOME
gsettings set org.gnome.desktop.wm.preferences button-layout appmenu
gsettings set org.gnome.Console audible-bell false
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>i']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>z']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super><Shift>s']"
gsettings set org.gnome.shell.keybindings screenshot "['Print']"
gsettings set org.gnome.shell.keybindings screenshot-window "['<Super>Print']"

gnome-extensions enable status-icons@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable drive-menu@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable launch-new-instance@gnome-shell-extensions.gcampax.github.com
