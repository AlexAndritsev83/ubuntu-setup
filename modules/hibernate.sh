#!/bin/bash

SWAP=$(swapon --show=NAME --noheadings | head -n1)

if [ -z "$SWAP" ]; then
  echo "❌ No swap detected!"
  exit 1
fi

UUID=$(blkid -s UUID -o value "$SWAP")

echo "resume=UUID=$UUID" | sudo tee /etc/initramfs-tools/conf.d/resume

sudo update-initramfs -u

sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"resume=UUID=$UUID /" /etc/default/grub

sudo update-grub
