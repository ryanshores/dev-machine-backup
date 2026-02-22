#! /bin/bash
# snapshot-repos.sh

# Default input/output directories
DEFAULT_INPUT="$HOME/Developer"
DEFAULT_OUTPUT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dev-state"

INPUT_DIR="${1:-$DEFAULT_INPUT}"
OUTPUT_DIR="${2:-$DEFAULT_OUTPUT}"

MANIFEST="$OUTPUT_DIR/repos.tsv"
mkdir -p "$(dirname "$MANIFEST")"

# Create a header with the "date" column
HEADER="path\torigin\tbranch\tstatus\tdate"
current_date=$(date +%Y-%m-%d)

echo "📁 Snapshotting repos in $INPUT_DIR..."

TEMP_MANIFEST=$(mktemp)
# Collect current repo states
find "$INPUT_DIR" -name ".git" -maxdepth 3 -type d | while read gitdir; do
    repo=$(dirname "$gitdir")
    origin=$(git -C "$repo" remote get-url origin 2>/dev/null || echo "no-remote")
    branch=$(git -C "$repo" branch --show-current 2>/dev/null || echo "unknown")
    dirty=$(git -C "$repo" status --porcelain 2>/dev/null | grep -v '??' | wc -l)
    dirty_trimmed=$(echo $dirty | xargs)
    status=$( [ "$dirty_trimmed" -gt 0 ] && echo "dirty($dirty_trimmed)" || echo "clean" )
    echo -e "${repo#$INPUT_DIR/}\t$origin\t$branch\t$status\t$current_date" >> "$TEMP_MANIFEST"
done

if [ -f "$MANIFEST" ]; then
    # Merge existing manifest with the new one
    # We use a temporary file to hold the merged result
    MERGED_MANIFEST=$(mktemp)
    
    # 1. Start with the header
    echo -e "$HEADER" > "$MERGED_MANIFEST"
    
    # 2. Add all entries from the current scan
    # 3. Add all entries from the existing manifest except the header
    # 4. Sort by path (column 1) and then by date (column 5) in descending order. 
    #    We also sort by the record source: current scan first (from cat $TEMP_MANIFEST) 
    #    then existing manifest (from tail). To do this, we can add a transient column.
    TAB=$(printf '\t')
    (awk -v FS="$TAB" -v OFS="$TAB" '{print $0, "1"}' "$TEMP_MANIFEST"; \
     tail -n +2 "$MANIFEST" | awk -v FS="$TAB" -v OFS="$TAB" '{print $0, "2"}') | \
        sort -t"$TAB" -k1,1 -k5,5r -k6,6n | \
        awk -F"$TAB" '!seen[$1,$5]++ {for(i=1; i<NF; i++) printf "%s%s", $i, (i==NF-1 ? ORS : FS)}' >> "$MERGED_MANIFEST"
    
    mv "$MERGED_MANIFEST" "$MANIFEST"
else
    # Just create the manifest from the new states, sorted by path
    TAB=$(printf '\t')
    (echo -e "$HEADER" && cat "$TEMP_MANIFEST" | sort -t"$TAB" -k1,1) > "$MANIFEST"
fi

rm "$TEMP_MANIFEST"

echo "✅ Snapshot updated in $MANIFEST"