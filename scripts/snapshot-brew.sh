#!/bin/bash
# snapshot-brew.sh

set -euo pipefail

# Default output directory
DEFAULT_OUTPUT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dev-state"
OUTPUT_DIR="${1:-$DEFAULT_OUTPUT}"

mkdir -p "$OUTPUT_DIR"

echo "📦 Snapshotting Homebrew..."

BREW_BIN="$(command -v brew || true)"
if [ -z "${BREW_BIN}" ]; then
  if [ -x "/opt/homebrew/bin/brew" ]; then
    BREW_BIN="/opt/homebrew/bin/brew"
  elif [ -x "/usr/local/bin/brew" ]; then
    BREW_BIN="/usr/local/bin/brew"
  fi
fi

if [ -z "${BREW_BIN}" ]; then
  echo "⚠️  Homebrew not found (brew not in PATH). Skipping Brewfile snapshot."
  echo "    Expected brew at /opt/homebrew/bin/brew (Apple Silicon) or /usr/local/bin/brew (Intel)."
  exit 0
fi

"$BREW_BIN" bundle dump --file="$OUTPUT_DIR/Brewfile" --force

echo "✅ Done. Written to $OUTPUT_DIR/Brewfile."