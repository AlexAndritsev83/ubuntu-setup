#!/usr/bin/env bash

echo "[ZSH] Installing..."

# якщо вже є oh-my-zsh — пропускаємо
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "[ZSH] Oh My Zsh already installed, skipping"
    exit 0
fi

sudo apt install -y zsh fonts-powerline curl git

# встановлення oh-my-zsh
RUNZSH=no CHSH=no sh -c \
"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions || true

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting || true

# config
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc

# default shell
chsh -s $(which zsh)

echo "[ZSH] Done"
