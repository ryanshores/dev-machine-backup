#!/bin/bash
# test-restore-logic.sh

set -e

# Setup temporary directories
TEST_INPUT=$(mktemp -d)
TEST_OUTPUT=$(mktemp -d)
RESTORE_TARGET=$(mktemp -d)

echo "🏗️ Setting up test environment..."

# Initialize a repo
mkdir -p "$TEST_INPUT/repo1"
cd "$TEST_INPUT/repo1"
git init
git config user.email "you@example.com"
git config user.name "Your Name"
touch file1.txt
git add file1.txt
git commit -m "initial commit"
cd - > /dev/null

# Run initial snapshot (Date 1)
# We will manually set the date in the manifest for testing
echo "📸 Creating initial snapshot..."
./snapshot-repos.sh "$TEST_INPUT" "$TEST_OUTPUT"
# Update date to 2024-01-01
# Note: repos.tsv is recreated or updated. After first snapshot, it exists.
# We use sed to change today's date to 2024-01-01
TODAY=$(date +%Y-%m-%d)
TAB=$(printf '\t')
sed -i '' "s/$TODAY/2024-01-01/g" "$TEST_OUTPUT/repos.tsv"

# Add another repo (Date 2)
mkdir -p "$TEST_INPUT/repo2"
cd "$TEST_INPUT/repo2"
git init
git config user.email "you@example.com"
git config user.name "Your Name"
touch file2.txt
git add file2.txt
git commit -m "repo2 commit"
cd - > /dev/null

echo "📸 Creating second snapshot..."
./snapshot-repos.sh "$TEST_INPUT" "$TEST_OUTPUT"
# The second snapshot will have today's date (e.g., 2026-02-22)
TODAY=$(date +%Y-%m-%d)

echo "--- Current Manifest ---"
cat "$TEST_OUTPUT/repos.tsv"
echo "------------------------"

# Test 1: Restore latest (no date)
echo "🧪 Test 1: Restore latest (no date)"
./restore-repos.sh "$RESTORE_TARGET/latest" "$TEST_OUTPUT"
if [ -d "$RESTORE_TARGET/latest/repo1" ] && [ -d "$RESTORE_TARGET/latest/repo2" ]; then
    echo "✅ Test 1 Passed: Both restored."
else
    echo "❌ Test 1 Failed."
    exit 1
fi

# Test 2: Restore to Today (Latest)
echo "🧪 Test 2: Restore to $TODAY"
./restore-repos.sh "$RESTORE_TARGET/today" "$TEST_OUTPUT" "$TODAY"
if [ -d "$RESTORE_TARGET/today/repo1" ] && [ -d "$RESTORE_TARGET/today/repo2" ]; then
    echo "✅ Test 2 Passed: repo1 and repo2 restored."
else
    echo "❌ Test 2 Failed."
    exit 1
fi

# Cleanup
rm -rf "$TEST_INPUT" "$TEST_OUTPUT" "$RESTORE_TARGET"
echo "🎉 All restore tests passed!"
