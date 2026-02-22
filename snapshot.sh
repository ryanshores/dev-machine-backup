#! /bin/bash
# snapshot.sh

echo "🚀 Starting snapshot process..."

# This script runs all snapshotting tasks: Homebrew, repos, etc.
# It can be run manually or set as a periodic task (e.g. via launchd).
# For simplicity, each snapshot task is a separate script that writes to the same iCloud folder.
# Run each snapshot script in sequence, so we can easily add more snapshot types in the future.

# Snapshot Homebrew
"./snapshot-brew.sh"

# Snapshot repos
"./snapshot-repos.sh"

echo "🎉 All snapshots complete. Your dev state is now saved to iCloud."
