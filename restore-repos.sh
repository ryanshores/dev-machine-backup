#! /bin/bash
# restore-repos.sh

# Default input/output directories
DEFAULT_INPUT="$HOME/Developer"
DEFAULT_OUTPUT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dev-state"

INPUT_DIR="${1:-$DEFAULT_INPUT}"
OUTPUT_DIR="${2:-$DEFAULT_OUTPUT}"
RESTORE_DATE="$3"

MANIFEST="$OUTPUT_DIR/repos.tsv"
echo "📁 Restoring repos from $MANIFEST..."

if [ ! -f "$MANIFEST" ]; then
    echo "⚠️  No manifest found at $MANIFEST. Skipping repo restore."
    exit 0
fi

if [ -n "$RESTORE_DATE" ]; then
    echo "📅 Restoring to date: $RESTORE_DATE"
else
    echo "📅 Restoring to latest version of each repo"
fi

# Use awk to filter entries and handle deduplication
# If RESTORE_DATE is provided, we filter by that date.
# If not, we take the first occurrence of each path (since the file is sorted by path and date descending).
TAB=$(printf '\t')
tail -n +2 "$MANIFEST" | awk -v FS="$TAB" -v OFS="$TAB" -v date="$RESTORE_DATE" '
    {
        if (date != "" ) {
            if ($5 == date) print $1, $2, $3, $4
        } else {
            if (!seen[$1]++) print $1, $2, $3, $4
        }
    }
' | while IFS=$'\t' read -r rel_path origin branch status; do
    full_path="$INPUT_DIR/$rel_path"
    if [ -d "$full_path/.git" ]; then
        echo "✅ Repo already exists at $full_path. Skipping."
    else
        if [ "$origin" != "no-remote" ]; then
            echo "🔄 Cloning $origin to $full_path..."
            mkdir -p "$(dirname "$full_path")"
            git clone --branch "$branch" "$origin" "$full_path"
        else
            echo "⚠️  No remote for $full_path. Creating empty repo..."
            mkdir -p "$full_path"
            git -C "$full_path" init
            if [ "$branch" != "unknown" ] && [ -n "$branch" ]; then
                git -C "$full_path" checkout -b "$branch" 2>/dev/null || true
            fi
        fi
    fi
done