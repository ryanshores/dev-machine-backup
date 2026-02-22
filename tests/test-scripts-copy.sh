#!/bin/bash
# tests/test-scripts-copy.sh

set -e

TEST_INPUT=$(mktemp -d)
TEST_OUTPUT=$(mktemp -d)

echo "🧪 Testing scripts copy to output directory..."

# Run snapshot
"$(dirname "$0")/../scripts/snapshot.sh" "$TEST_INPUT" "$TEST_OUTPUT"

# Verify files exist in output
if [ -f "$TEST_OUTPUT/restore.sh" ] && \
   [ -f "$TEST_OUTPUT/scripts/restore.sh" ] && \
   [ -f "$TEST_OUTPUT/scripts/restore-brew.sh" ] && \
   [ -f "$TEST_OUTPUT/scripts/restore-repos.sh" ]; then
    echo "✅ All restore scripts copied successfully."
else
    echo "❌ Restore scripts missing in output directory."
    ls -R "$TEST_OUTPUT"
    exit 1
fi

# Verify executability
if [ -x "$TEST_OUTPUT/restore.sh" ] && [ -x "$TEST_OUTPUT/scripts/restore-repos.sh" ]; then
    echo "✅ Restore scripts are executable."
else
    echo "❌ Restore scripts are not executable."
    exit 1
fi

# Cleanup
rm -rf "$TEST_INPUT" "$TEST_OUTPUT"
echo "🎉 Scripts copy test passed!"
