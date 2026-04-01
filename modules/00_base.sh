#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install -y \
git curl wget htop neovim \
build-essential unzip \
gnome-tweaks tlp \
ca-certificates gnupg lsb-release

sudo systemctl enable tlp
