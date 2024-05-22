#!/usr/bin/env bash

cliPkgList="$(cat cli_pkgs.txt | awk '{print $1}' | paste -sd' ')"
sudo pacman -Syu $pkgList
