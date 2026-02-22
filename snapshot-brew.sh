#!/bin/bash
# snapshot-brew.sh

DEV_STATE="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dev-state"
mkdir -p "$DEV_STATE"

echo "📦 Snapshotting Homebrew..."
brew bundle dump --file="$DEV_STATE/Brewfile" --force

echo "✅ Done. Written to $DEV_STATE/Brewfile."