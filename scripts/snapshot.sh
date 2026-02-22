#! /bin/bash
# snapshot.sh
echo "================================="
echo "🚀 Starting snapshot process..."

# Default input/output directories
DEFAULT_INPUT="$HOME/Developer"
DEFAULT_OUTPUT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dev-state"

INPUT_DIR="${1:-$DEFAULT_INPUT}"
OUTPUT_DIR="${2:-$DEFAULT_OUTPUT}"

# This script runs all snapshotting tasks: Homebrew, repos, etc.
# It can be run manually or set as a periodic task (e.g. via launchd).
# For simplicity, each snapshot task is a separate script that writes to the same iCloud folder.
# Run each snapshot script in sequence, so we can easily add more snapshot types in the future.

# Snapshot Homebrew
"$(dirname "$0")/snapshot-brew.sh" "$OUTPUT_DIR"

# Snapshot repos
"$(dirname "$0")/snapshot-repos.sh" "$INPUT_DIR" "$OUTPUT_DIR"

# Copy restore scripts to the output directory
echo "📂 Copying restore scripts to $OUTPUT_DIR/scripts..."
mkdir -p "$OUTPUT_DIR/scripts"
cp "$(dirname "$0")/restore.sh" "$OUTPUT_DIR/restore.sh"
cp "$(dirname "$0")/restore.sh" "$OUTPUT_DIR/scripts/restore.sh"
cp "$(dirname "$0")/restore-brew.sh" "$OUTPUT_DIR/scripts/restore-brew.sh"
cp "$(dirname "$0")/restore-repos.sh" "$OUTPUT_DIR/scripts/restore-repos.sh"
chmod +x "$OUTPUT_DIR/restore.sh" "$OUTPUT_DIR/scripts/"*.sh

echo "🎉 All snapshots complete. Your dev state is now saved."
echo "================================="