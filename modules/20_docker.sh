#!/usr/bin/env bash

echo "[DOCKER] Installing Docker..."

# якщо вже є docker — виходимо
if command -v docker &> /dev/null; then
    echo "[DOCKER] Docker already installed, skipping"
    exit 0
fi

set -e

# 1. Підготовка
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

# 2. Keyrings директорія
sudo install -m 0755 -d /etc/apt/keyrings

# 3. Завантаження ключа (безпечний варіант)
if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
    echo "[DOCKER] Adding GPG key..."
    
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o docker.gpg
    
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    
    rm docker.gpg
fi

# 4. Repo
if [[ ! -f /etc/apt/sources.list.d/docker.list ]]; then
    echo "[DOCKER] Adding repository..."
    
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

# 5. Install
sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 6. Додати користувача в групу
sudo usermod -aG docker "$USER"

echo "[DOCKER] Installed successfully"
echo "⚠️ Logout/login required for Docker group"
