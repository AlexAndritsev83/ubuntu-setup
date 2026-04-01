#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="setup.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "🚀 Ubuntu Setup Starting..."

# check sudo
if ! sudo -v; then
  echo "❌ This script requires sudo privileges"
  exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run_module() {
  local module="$1"

  echo "➡️ Running $module"

  if [[ -f "$DIR/modules/$module" ]]; then
    bash "$DIR/modules/$module"
    echo "✅ $module done"
  else
    echo "⚠️ Module $module not found"
  fi
}

# run all modules in order
for module in $(ls "$DIR/modules" | sort); do
  run_module "$module"
done

echo "✅ ALL DONE!"
echo "🔁 Reboot recommended"
