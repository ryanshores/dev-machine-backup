#!/bin/bash
# restore-brew.sh

DEV_STATE="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dev-state"
mkdir -p "$DEV_STATE"

echo "📦 Restoring Homebrew..."
brew bundle install --file="$DEV_STATE/Brewfile"

echo "✅ Done. Syncing to iCloud..."