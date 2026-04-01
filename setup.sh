#!/usr/bin/env bash

echo "🚀 Ubuntu Setup Starting..."

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FAILED=()
SUCCESS=()

run_module() {
    local module=$1
    echo "➡️ Running $module..."

    if bash "$DIR/modules/$module"; then
        echo "✅ $module OK"
        SUCCESS+=("$module")
    else
        echo "❌ $module FAILED"
        FAILED+=("$module")
    fi
}

run_module 00_base.sh
run_module 10_locale.sh
run_module 20_docker.sh
run_module 30_hibernate.sh
run_module 40_dev.sh
run_module 50_zsh.sh
run_module 60_theme.sh

echo ""
echo "========================="
echo "📊 SUMMARY"
echo "========================="

echo "✅ SUCCESS:"
for m in "${SUCCESS[@]}"; do
    echo "  - $m"
done

echo ""

if [ ${#FAILED[@]} -ne 0 ]; then
    echo "❌ FAILED:"
    for m in "${FAILED[@]}"; do
        echo "  - $m"
    done
else
    echo "🎉 ALL MODULES SUCCESSFUL"
fi

echo ""
echo "🔁 Reboot recommended"

read -p "Reload shell now? (y/n): " ans
if [ "$ans" = "y" ]; then
    exec zsh
fi
