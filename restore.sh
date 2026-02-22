#! /bin/bash

echo "🚀 Starting restore process...

# This script runs all restore tasks: Homebrew, repos, etc.

# It can be run manually or set as a periodic task (e.g. via launchd).
# For simplicity, each restore task is a separate script that reads from the same iCloud folder.

# Restore Homebrew
./restore-brew.sh
# Restore repos
./restore-repos.sh

echo "🎉 All restores complete. Your dev state should now be restored from iCloud."