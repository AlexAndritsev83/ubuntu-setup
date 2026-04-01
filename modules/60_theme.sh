#!/usr/bin/env bash

echo "[THEME] Setting up beautiful terminal..."

ZSH_DIR="$HOME/.oh-my-zsh"
ZSHRC="$HOME/.zshrc"

# -------------------------
# install fonts
# -------------------------
echo "[THEME] Installing fonts..."
sudo apt update
sudo apt install -y fonts-firacode fonts-powerline

# -------------------------
# install powerlevel10k
# -------------------------
if [[ ! -d "$ZSH_DIR/custom/themes/powerlevel10k" ]]; then
    echo "[THEME] Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k \
        "$ZSH_DIR/custom/themes/powerlevel10k"
else
    echo "[THEME] powerlevel10k already installed"
fi

# -------------------------
# set theme
# -------------------------
if grep -q "^ZSH_THEME=" "$ZSHRC"; then
    sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$ZSHRC"
else
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$ZSHRC"
fi

# -------------------------
# dark mode (gnome)
# -------------------------
echo "[THEME] Enabling dark mode..."
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# -------------------------
# better terminal settings
# -------------------------
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code 12'

# -------------------------
# aliases (nice UX)
# -------------------------
add_alias () {
    local alias_line=$1
    grep -qxF "$alias_line" "$ZSHRC" || echo "$alias_line" >> "$ZSHRC"
}

echo "[THEME] Adding useful aliases..."

add_alias 'alias ll="ls -lah"'
add_alias 'alias gs="git status"'
add_alias 'alias gc="git commit"'
add_alias 'alias gp="git push"'
add_alias 'alias dc="docker compose"'

# -------------------------
# enable powerlevel10k config
# -------------------------
if [[ ! -f "$HOME/.p10k.zsh" ]]; then
    echo "[THEME] First run will ask for config wizard"
fi

echo "[THEME] DONE"
echo "👉 Run: exec zsh"
