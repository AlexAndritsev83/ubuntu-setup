#!/usr/bin/env bash

echo "[BASE] Updating system..."

sudo apt update

if ! dpkg -l | grep -q curl; then
  sudo apt install -y \
    git curl wget htop neovim \
    build-essential unzip \
    gnome-tweaks tlp \
    ca-certificates gnupg lsb-release
fi

sudo systemctl enable tlp || true
