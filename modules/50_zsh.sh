#!/usr/bin/env bash

echo "[ZSH] Installing..."

if command -v zsh &> /dev/null; then
  echo "Zsh already installed, skipping"
  exit 0
fi

sudo apt install -y zsh fonts-powerline

RUNZSH=no CHSH=no sh -c \
"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting || true

# safe config update
if [[ -f ~/.zshrc ]]; then
  if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
  fi

  sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc || true
fi

echo "⚠️ Run manually if needed: chsh -s $(which zsh)"
