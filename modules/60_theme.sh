#!/usr/bin/env bash

echo "[THEME] Ultra terminal setup..."

# -------------------------
# FONT
# -------------------------
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts || exit

if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    echo "[FONT] Installing JetBrainsMono Nerd Font..."

    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o JetBrainsMono.zip
    rm JetBrainsMono.zip

    fc-cache -fv
else
    echo "[FONT] Already installed"
fi

gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font 12"

# -------------------------
# TERMINAL PROFILE
# -------------------------
PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
BASE="/org/gnome/terminal/legacy/profiles:/:$PROFILE/"

echo "[THEME] Applying terminal theme..."

gsettings set org.gnome.Terminal.Legacy.Profile:$BASE use-theme-colors false

# GitHub Dark colors
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE background-color '#0d1117'
gsettings set org.gnome.Terminal.Legacy.Profile:$BASE foreground-color '#c9d1d9'

gsettings set org.gnome.Terminal.Legacy.Profile:$BASE palette "[
'#161b22','#f85149','#2ea043','#d29922',
'#58a6ff','#bc8cff','#39c5cf','#c9d1d9',
'#8b949e','#ff7b72','#3fb950','#e3b341',
'#79c0ff','#d2a8ff','#56d4dd','#f0f6fc'
]"

# Transparency (легка)
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

# -------------------------
# DEV TOOLS (LOOK)
# -------------------------
echo "[THEME] Installing CLI enhancements..."

sudo apt install -y eza

# -------------------------
# ZSH PLUGINS
# -------------------------
mkdir -p ~/.zsh

if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

if [ ! -d ~/.zsh/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
fi

# -------------------------
# ZSH CONFIG FIX
# -------------------------
echo "[THEME] Fixing .zshrc..."

if [ ! -f ~/.zshrc ]; then
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc 2>/dev/null || touch ~/.zshrc
fi

# Backup
cp ~/.zshrc ~/.zshrc.bak.$(date +%s)

# Plugins
if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
fi

# Theme
sed -i 's|ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc

# Aliases
cat << 'EOF' >> ~/.zshrc

# --- DEV ALIASES ---
alias ls="eza --icons"
alias ll="eza -lh --icons"
alias la="eza -lha --icons"
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"

# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

EOF

# -------------------------
# POWERLEVEL10K CONFIG
# -------------------------
echo "[THEME] Applying p10k config..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

P10K_SOURCE="$PROJECT_ROOT/templates/p10k.zsh"
P10K_TARGET="$HOME/.p10k.zsh"

if [ -f "$P10K_SOURCE" ]; then
    echo "[P10K] Found template, applying..."

    # backup якщо вже існує
    if [ -f "$P10K_TARGET" ]; then
        cp "$P10K_TARGET" "$P10K_TARGET.bak.$(date +%s)"
    fi

    cp "$P10K_SOURCE" "$P10K_TARGET"
else
    echo "[P10K] Template not found, skipping"
fi
