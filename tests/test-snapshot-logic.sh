#!/bin/bash
# test-snapshot-logic.sh

set -e

# Setup test directories
TEST_INPUT="$(pwd)/test-repos"
TEST_OUTPUT="$(pwd)/test-output"
rm -rf "$TEST_INPUT" "$TEST_OUTPUT"
mkdir -p "$TEST_INPUT" "$TEST_OUTPUT"

# Helper to create a git repo
create_repo() {
    local name=$1
    local dir="$TEST_INPUT/$name"
    mkdir -p "$dir"
    cd "$dir"
    git init -q
    git config user.email "test@example.com"
    git config user.name "Test User"
    touch file.txt
    git add file.txt
    git commit -m "initial" -q
    cd - > /dev/null
}

echo "1. Creating initial repositories..."
create_repo "repo1"
create_repo "repo2"

echo "2. Running first snapshot..."
"$(dirname "$0")/../scripts/snapshot-repos.sh" "$TEST_INPUT" "$TEST_OUTPUT"

echo "--- Initial Manifest ---"
cat "$TEST_OUTPUT/repos.tsv"
echo "------------------------"

echo -e "\n3. Modifying repo1 and adding repo3..."
# Modify repo1
echo "change" >> "$TEST_INPUT/repo1/file.txt"
# Create repo3
create_repo "repo3"

echo "4. Simulating an old entry in the manifest for repo2..."
# We'll manually append an old entry for repo2 to test deduplication/update
# The script should keep the NEWEST entry.
TAB=$(printf '\t')
echo -e "repo2${TAB}no-remote${TAB}main${TAB}clean${TAB}2020-01-01" >> "$TEST_OUTPUT/repos.tsv"

echo "5. Running second snapshot..."
"$(dirname "$0")/../scripts/snapshot-repos.sh" "$TEST_INPUT" "$TEST_OUTPUT"

echo "--- Updated Manifest ---"
cat "$TEST_OUTPUT/repos.tsv"
echo "------------------------"

# Verification
echo -e "\n6. Verifying results..."
# Check if repo1 is dirty
if grep "repo1" "$TEST_OUTPUT/repos.tsv" | grep -q "dirty(1)"; then
    echo "✅ repo1 correctly marked as dirty."
else
    echo "❌ repo1 NOT marked as dirty correctly."
    exit 1
fi

# Check if repo3 exists
if grep -q "repo3" "$TEST_OUTPUT/repos.tsv"; then
    echo "✅ repo3 added."
else
    echo "❌ repo3 missing."
    exit 1
fi

# Check for deduplication (repo2 should appear only once with current date)
REPO2_COUNT=$(grep -c "repo2" "$TEST_OUTPUT/repos.tsv")
CURRENT_DATE=$(date +%Y-%m-%d)
if [ "$REPO2_COUNT" -eq 1 ] && grep "repo2" "$TEST_OUTPUT/repos.tsv" | grep -q "$CURRENT_DATE"; then
    echo "✅ repo2 deduplicated (only current entry exists)."
else
    echo "❌ repo2 deduplication failed (Count: $REPO2_COUNT)."
    exit 1
fi

echo -e "\n🎉 All tests passed!"
