#!/usr/bin/env bash

echo "[LOCALE] Setting locale..."

sudo update-locale LANG=en_US.UTF-8 \
  LC_TIME=uk_UA.UTF-8 \
  LC_NUMERIC=uk_UA.UTF-8 \
  LC_MONETARY=uk_UA.UTF-8 \
  LC_MEASUREMENT=uk_UA.UTF-8

# gsettings may fail on headless systems
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt>Shift_L']" || true
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift>Alt_L']" || true
gsettings set org.gnome.desktop.input-sources xkb-options "['grp:alt_shift_toggle']" || true

sudo apt install -y hunspell-uk
