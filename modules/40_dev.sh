#!/usr/bin/env bash

echo "[DEV] Installing dev tools..."

sudo apt install -y \
  python3 python3-pip \
  nodejs npm \
  golang \
  ripgrep fd-find \
  fzf
