#! /bin/bash
# snapshot-repos.sh

# Default input/output directories
DEFAULT_INPUT="$HOME/Developer"
DEFAULT_OUTPUT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dev-state"

INPUT_DIR="${1:-$DEFAULT_INPUT}"
OUTPUT_DIR="${2:-$DEFAULT_OUTPUT}"

MANIFEST="$OUTPUT_DIR/repos.tsv"
mkdir -p "$(dirname "$MANIFEST")"

echo -e "path\torigin\tbranch\tstatus" > "$MANIFEST"

echo "📁 Snapshotting repos in $INPUT_DIR..."

find "$INPUT_DIR" -name ".git" -maxdepth 3 -type d | while read gitdir; do
    repo=$(dirname "$gitdir")
    origin=$(git -C "$repo" remote get-url origin 2>/dev/null || echo "no-remote")
    branch=$(git -C "$repo" branch --show-current 2>/dev/null || echo "unknown")
    dirty=$(git -C "$repo" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    status=$( [ "$dirty" -gt 0 ] && echo "dirty($dirty)" || echo "clean" )
    echo -e "${repo#$INPUT_DIR/}\t$origin\t$branch\t$status" >> "$MANIFEST"
done

echo "✅ Snapshot written to $MANIFEST"