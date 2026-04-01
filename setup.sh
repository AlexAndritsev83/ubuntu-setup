#!/bin/bash

set -e

echo "🚀 Ubuntu Setup Starting..."

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run_module() {
    echo "➡️ Running $1..."
    bash "$DIR/modules/$1"
}

run_module base.sh
run_module locale.sh
run_module docker.sh
run_module hibernate.sh
run_module dev.sh
run_module zsh.sh

echo "✅ ALL DONE!"
echo "👉 Reboot recommended"
