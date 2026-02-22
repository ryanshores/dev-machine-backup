#!/bin/bash
# restore-brew.sh

set -euo pipefail

# Default output directory
DEFAULT_OUTPUT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dev-state"
OUTPUT_DIR="${1:-$DEFAULT_OUTPUT}"

echo "📦 Restoring Homebrew from $OUTPUT_DIR/Brewfile..."

BREW_BIN="$(command -v brew || true)"
if [ -z "${BREW_BIN}" ]; then
  if [ -x "/opt/homebrew/bin/brew" ]; then
    BREW_BIN="/opt/homebrew/bin/brew"
  elif [ -x "/usr/local/bin/brew" ]; then
    BREW_BIN="/usr/local/bin/brew"
  fi
fi

if [ -z "${BREW_BIN}" ]; then
  echo "⚠️  Homebrew not found (brew not in PATH). Skipping Brewfile restore."
  exit 0
fi

if [ -f "$OUTPUT_DIR/Brewfile" ]; then
  "$BREW_BIN" bundle install --file="$OUTPUT_DIR/Brewfile"
  echo "✅ Homebrew restore complete."
else
  echo "⚠️  No Brewfile found at $OUTPUT_DIR/Brewfile. Skipping."
fi