#! /bin/bash
# snapshot-repos.sh

MANIFEST="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dev-state/repos.tsv"
mkdir -p "$(dirname "$MANIFEST")"

echo -e "path\torigin\tbranch\tstatus" > "$MANIFEST"

echo "📁 Snapshotting repos in $HOME/Developer..."

find "$HOME/Developer" -name ".git" -maxdepth 3 -type d | while read gitdir; do
    repo=$(dirname "$gitdir")
    origin=$(git -C "$repo" remote get-url origin 2>/dev/null || echo "no-remote")
    branch=$(git -C "$repo" branch --show-current 2>/dev/null || echo "unknown")
    dirty=$(git -C "$repo" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    status=$( [ "$dirty" -gt 0 ] && echo "dirty($dirty)" || echo "clean" )
    echo -e "${repo#$HOME/}\t$origin\t$branch\t$status" >> "$MANIFEST"
done

echo "✅ Snapshot written to $MANIFEST"