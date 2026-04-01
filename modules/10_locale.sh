#!/usr/bin/env bash

echo "[LOCALE] Setting locale..."

sudo update-locale LANG=en_US.UTF-8 \
  LC_TIME=uk_UA.UTF-8 \
  LC_NUMERIC=uk_UA.UTF-8 \
  LC_MONETARY=uk_UA.UTF-8 \
  LC_MEASUREMENT=uk_UA.UTF-8

# keyboard layout
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ua+winkeys')]"

gsettings set org.gnome.desktop.input-sources xkb-options "['grp:alt_shift_toggle']"

# dark mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# fallback safety
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt>Shift_L']" || true
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift>Alt_L']" || true

sudo apt install -y hunspell-uk
