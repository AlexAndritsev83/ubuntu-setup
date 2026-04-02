#!/usr/bin/env bash

echo "[HIBERNATE] Configuring suspend-then-hibernate..."

# Enable suspend-then-hibernate in systemd
sudo mkdir -p /etc/systemd
sudo sed -i 's/^#AllowSuspendThenHibernate=.*/AllowSuspendThenHibernate=yes/' /etc/systemd/sleep.conf 2>/dev/null || true

if ! grep -q "AllowSuspendThenHibernate" /etc/systemd/sleep.conf; then
  echo "AllowSuspendThenHibernate=yes" | sudo tee -a /etc/systemd/sleep.conf
fi

if ! grep -q "HibernateDelaySec" /etc/systemd/sleep.conf; then
  echo "HibernateDelaySec=180" | sudo tee -a /etc/systemd/sleep.conf
else
  sudo sed -i 's/^HibernateDelaySec=.*/HibernateDelaySec=180/' /etc/systemd/sleep.conf
fi

# Configure lid close behavior
sudo sed -i 's/^#HandleLidSwitch=.*/HandleLidSwitch=suspend-then-hibernate/' /etc/systemd/logind.conf 2>/dev/null || true

if ! grep -q "HandleLidSwitch" /etc/systemd/logind.conf; then
  echo "HandleLidSwitch=suspend-then-hibernate" | sudo tee -a /etc/systemd/logind.conf
fi

# Disable GNOME override
gsettings set org.gnome.settings-daemon.plugins.power lid-close-ac-action 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action 'nothing'

# Enable service
sudo systemctl enable systemd-suspend-then-hibernate.service

# Fix USB hibernate issue (xhci)
echo "[HIBERNATE] Applying USB fix..."

sudo tee /lib/systemd/system-sleep/disable-usb >/dev/null << 'EOF'
#!/bin/bash

case $1/$2 in
  pre/*)
    echo -n '0000:00:14.0' > /sys/bus/pci/drivers/xhci_hcd/unbind
    ;;
  post/*)
    echo -n '0000:00:14.0' > /sys/bus/pci/drivers/xhci_hcd/bind
    ;;
esac
EOF

sudo chmod +x /lib/systemd/system-sleep/disable-usb

echo "[HIBERNATE] Done. Reboot required."
