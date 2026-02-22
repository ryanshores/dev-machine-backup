#!/bin/bash
# restore-brew.sh

# Default output directory
DEFAULT_OUTPUT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dev-state"
OUTPUT_DIR="${1:-$DEFAULT_OUTPUT}"

echo "📦 Restoring Homebrew from $OUTPUT_DIR/Brewfile..."
if [ -f "$OUTPUT_DIR/Brewfile" ]; then
    brew bundle install --file="$OUTPUT_DIR/Brewfile"
    echo "✅ Homebrew restore complete."
else
    echo "⚠️  No Brewfile found at $OUTPUT_DIR/Brewfile. Skipping."
fi