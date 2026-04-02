#!/usr/bin/env bash

set -e

echo "=================================="
echo "[THEME] Full UI setup..."
echo "=================================="

# -------------------------
# PATHS
# -------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# -------------------------
# FONT INSTALL (CLEAN)
# -------------------------
echo "[FONT] Installing JetBrainsMono Nerd Font..."

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts || exit

if ! fc-list | grep -qi "JetBrainsMono Nerd Font Mono"; then
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
    tar -xf JetBrainsMono.tar.xz
fi

# remove problematic fonts
rm -f ~/.local/share/fonts/JetBrainsMonoNL*
rm -f ~/.local/share/fonts/*Propo*

# rebuild cache
fc-cache -fv >/dev/null

# apply font to GNOME Terminal
echo "[FONT] Applying..."

PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
BASE="/org/gnome/terminal/legacy/profiles:/:$PROFILE/"

gsettings set org.gnome.Terminal.Legacy.Profile:$BASE use-system-font false
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE font 'JetBrainsMono Nerd Font Mono 12'

# -------------------------
# TOKYO NIGHT THEME
# -------------------------
echo "[THEME] Applying Tokyo Night..."

gsettings set org.gnome.Terminal.Legacy.Profile:$BASE use-theme-colors false

gsettings set org.gnome.Terminal.Legacy.Profile:$BASE background-color '#1a1b26'
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE foreground-color '#c0caf5'

gsettings set org.gnome.Terminal.Legacy.Profile:$BASE palette "[
'#15161e', '#f7768e', '#9ece6a', '#e0af68',
'#7aa2f7', '#bb9af7', '#7dcfff', '#a9b1d6',
'#414868', '#f7768e', '#9ece6a', '#e0af68',
'#7aa2f7', '#bb9af7', '#7dcfff', '#c0caf5'
]"

gsettings set org.gnome.Terminal.Legacy.Profile:$BASE cursor-colors-set true
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE cursor-foreground-color '#1a1b26'
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE cursor-background-color '#c0caf5'

gsettings set org.gnome.Terminal.Legacy.Profile:$BASE use-transparent-background true
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE background-transparency-percent 10

gsettings set org.gnome.Terminal.Legacy.Profile:$BASE bold-is-bright false

# -------------------------
# CLI TOOLS
# -------------------------
echo "[DEV] Installing CLI tools..."

sudo apt-get update -y >/dev/null
sudo apt-get install -y eza >/dev/null

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
    [ -f "$ZSHRC_TARGET" ] && cp "$ZSHRC_TARGET" "$ZSHRC_TARGET.bak.$(date +%s)"
    cp "$ZSHRC_SOURCE" "$ZSHRC_TARGET"
fi

# -------------------------
# POWERLEVEL10K
# -------------------------
echo "[P10K] Installing..."

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k" >/dev/null
fi

# apply p10k config
P10K_SOURCE="$PROJECT_ROOT/templates/p10k.zsh"
P10K_TARGET="$HOME/.p10k.zsh"

if [ -f "$P10K_SOURCE" ]; then
    [ -f "$P10K_TARGET" ] && cp "$P10K_TARGET" "$P10K_TARGET.bak.$(date +%s)"
    cp "$P10K_SOURCE" "$P10K_TARGET"
fi

# ensure p10k is loaded
if ! grep -q "p10k.zsh" ~/.zshrc; then
    echo '[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh' >> ~/.zshrc
fi

# -------------------------
# FINAL
# -------------------------
echo ""
echo "=================================="
echo "✅ THEME READY"
echo "=================================="
echo ""

echo "👉 Run: exec zsh"
