#!/usr/bin/env bash

echo "[BASE] Updating system..."

sudo apt update

# ensure core tools
sudo apt install -y \
  git curl wget htop neovim \
  build-essential unzip \
  gnome-tweaks tlp \
  ca-certificates gnupg lsb-release

sudo systemctl enable tlp || true
