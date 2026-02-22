#! /bin/bash

echo "🚀 Starting restore process..."

# This script runs all restore tasks: Homebrew, repos, etc.
# $1: Restore target directory (optional)
# $2: Backup source directory (optional)
# $3: Restore date (optional)

# Restore Homebrew
"$(dirname "$0")/restore-brew.sh" "$2"

# Restore repos
"$(dirname "$0")/restore-repos.sh" "$1" "$2" "$3"

echo "🎉 All restores complete. Your dev state should now be restored."