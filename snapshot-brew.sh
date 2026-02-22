#!/bin/bash
# snapshot-brew.sh

# Default output directory
DEFAULT_OUTPUT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dev-state"
OUTPUT_DIR="${1:-$DEFAULT_OUTPUT}"

mkdir -p "$OUTPUT_DIR"

echo "📦 Snapshotting Homebrew..."
brew bundle dump --file="$OUTPUT_DIR/Brewfile" --force

echo "✅ Done. Written to $OUTPUT_DIR/Brewfile."