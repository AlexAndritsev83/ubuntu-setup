#!/usr/bin/env bash

echo "[ZSH] Setup started..."

ZSH_DIR="$HOME/.oh-my-zsh"
ZSHRC="$HOME/.zshrc"
BACKUP="$HOME/.zshrc.backup.$(date +%s)"

# -------------------------
# install packages
# -------------------------
sudo apt update
sudo apt install -y zsh fonts-powerline curl git

# -------------------------
# install oh-my-zsh
# -------------------------
if [[ ! -d "$ZSH_DIR" ]]; then
    echo "[ZSH] Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "[ZSH] Oh My Zsh already installed"
fi

# -------------------------
# backup .zshrc
# -------------------------
if [[ -f "$ZSHRC" ]]; then
    cp "$ZSHRC" "$BACKUP"
    echo "[ZSH] Backup created: $BACKUP"
fi

# -------------------------
# ensure .zshrc exists
# -------------------------
if [[ ! -f "$ZSHRC" ]]; then
    echo "[ZSH] Creating new .zshrc"
    cp "$ZSH_DIR/templates/zshrc.zsh-template" "$ZSHRC"
fi

# -------------------------
# plugins install
# -------------------------
install_plugin () {
    local repo=$1
    local name=$2

    if [[ ! -d "$ZSH_DIR/custom/plugins/$name" ]]; then
        echo "[ZSH] Installing plugin: $name"
        git clone "$repo" "$ZSH_DIR/custom/plugins/$name"
    else
        echo "[ZSH] Plugin exists: $name"
    fi
}

install_plugin https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions
install_plugin https://github.com/zsh-users/zsh-syntax-highlighting zsh-syntax-highlighting

# -------------------------
# ensure plugins in config
# -------------------------
if grep -q "^plugins=" "$ZSHRC"; then
    sed -i 's/plugins=(.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$ZSHRC"
else
    echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> "$ZSHRC"
fi

# -------------------------
# theme
# -------------------------
if grep -q "^ZSH_THEME=" "$ZSHRC"; then
    sed -i 's/ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$ZSHRC"
else
    echo 'ZSH_THEME="agnoster"' >> "$ZSHRC"
fi

# -------------------------
# useful defaults
# -------------------------
grep -q "ENABLE_CORRECTION" "$ZSHRC" || echo 'ENABLE_CORRECTION="true"' >> "$ZSHRC"
grep -q "HISTSIZE" "$ZSHRC" || echo 'HISTSIZE=10000' >> "$ZSHRC"
grep -q "SAVEHIST" "$ZSHRC" || echo 'SAVEHIST=10000' >> "$ZSHRC"

# -------------------------
# set default shell
# -------------------------
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "[ZSH] Setting zsh as default shell"
    chsh -s "$(which zsh)"
fi

echo "[ZSH] Setup DONE"
echo "👉 Restart terminal or run: exec zsh"
