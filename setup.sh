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

# =========================
# CORE SETUP
# =========================

run_module 00_base.sh
run_module 10_locale.sh
run_module 20_docker.sh
run_module 30_hibernate.sh
run_module 40_dev.sh
run_module 50_zsh.sh

# =========================
# OPTIONAL MODULES
# =========================

ENABLE_THEME=${ENABLE_THEME:-false}

if [ "$ENABLE_THEME" = true ]; then
    run_module 60_theme.sh
fi

# =========================
# SUMMARY
# =========================

echo ""
echo "========================="
echo "📊 SUMMARY"
echo "========================="

echo ""
echo "✅ SUCCESS:"
for m in "${SUCCESS[@]}"; do
  echo "  - $m"
done

echo ""
echo "❌ FAILED:"
for m in "${FAILED[@]}"; do
  echo "  - $m"
done

echo ""
