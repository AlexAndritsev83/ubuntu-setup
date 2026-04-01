#!/usr/bin/env bash

set -e

echo "=================================="
echo "[THEME] Ultra terminal setup..."
echo "=================================="

# -------------------------
# PATHS
# -------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# -------------------------
# FONT INSTALL
# -------------------------
echo "[FONT] Installing JetBrainsMono Nerd Font..."

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts || exit

if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o JetBrainsMono.zip >/dev/null
    rm JetBrainsMono.zip
    fc-cache -fv >/dev/null
    echo "[FONT] Installed"
else
    echo "[FONT] Already installed"
fi

# -------------------------
# TERMINAL SETTINGS
# -------------------------
echo "[TERMINAL] Applying theme..."

PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
BASE="/org/gnome/terminal/legacy/profiles:/:$PROFILE/"

gsettings set org.gnome.Terminal.Legacy.Profile:$BASE use-theme-colors false

# Colors (GitHub Dark)
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE background-color '#0d1117'
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE foreground-color '#c9d1d9'

gsettings set org.gnome.Terminal.Legacy.Profile:$BASE palette "[
'#161b22','#f85149','#2ea043','#d29922',
'#58a6ff','#bc8cff','#39c5cf','#c9d1d9',
'#8b949e','#ff7b72','#3fb950','#e3b341',
'#79c0ff','#d2a8ff','#56d4dd','#f0f6fc'
]"

# Transparency
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE use-transparent-background true
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE background-transparency-percent 10

# Cursor
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE cursor-shape 'ibeam'
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE cursor-blink-mode 'off'

# Font
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE use-system-font false
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE font 'JetBrainsMono Nerd Font 12'

# Bell off
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE audible-bell false

echo "[TERMINAL] Done"

# -------------------------
# CLI TOOLS
# -------------------------
echo "[DEV] Installing CLI tools..."

sudo apt update -y >/dev/null
sudo apt install -y eza >/dev/null

# -------------------------
# ZSH PLUGINS
# -------------------------
echo "[ZSH] Installing plugins..."

mkdir -p ~/.zsh

if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions >/dev/null
fi

if [ ! -d ~/.zsh/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting >/dev/null
fi

# -------------------------
# ZSHRC TEMPLATE
# -------------------------
echo "[ZSHRC] Applying template..."

ZSHRC_SOURCE="$PROJECT_ROOT/templates/zshrc"
ZSHRC_TARGET="$HOME/.zshrc"

if [ -f "$ZSHRC_SOURCE" ]; then
    if [ -f "$ZSHRC_TARGET" ]; then
        cp "$ZSHRC_TARGET" "$ZSHRC_TARGET.bak.$(date +%s)"
    fi
    cp "$ZSHRC_SOURCE" "$ZSHRC_TARGET"
    echo "[ZSHRC] Applied"
else
    echo "[ZSHRC] Template not found"
fi

# -------------------------
# P10K CONFIG
# -------------------------
echo "[P10K] Applying config..."

P10K_SOURCE="$PROJECT_ROOT/templates/p10k.zsh"
P10K_TARGET="$HOME/.p10k.zsh"

if [ -f "$P10K_SOURCE" ]; then
    if [ -f "$P10K_TARGET" ]; then
        cp "$P10K_TARGET" "$P10K_TARGET.bak.$(date +%s)"
    fi
    cp "$P10K_SOURCE" "$P10K_TARGET"
    echo "[P10K] Applied"
else
    echo "[P10K] Template not found"
fi

# -------------------------
# FINAL
# -------------------------
echo ""
echo "=================================="
echo "✅ THEME SETUP COMPLETE"
echo "=================================="
echo ""

# Reload shell
if [ -n "$ZSH_VERSION" ]; then
    echo "[INFO] Reloading ZSH..."
    exec zsh
else
    echo "👉 Run: exec zsh"
fi
