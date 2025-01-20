#! /bin/bash

ln git/Betterfox/user.js ~/.mozilla/firefox/*.default-release/.

mkdir -p ~/.config
mkdir -p ~/.local/share
stow .
