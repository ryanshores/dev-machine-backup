#! /bin/bash
# restore-repos.sh

DEV_STATE="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dev-state"
MANIFEST="$DEV_STATE/repos.tsv"
echo "📁 Restoring repos from $MANIFEST..."

if [ ! -f "$MANIFEST" ]; then
    echo "⚠️  No manifest found at $MANIFEST. Skipping repo restore."
    exit 0
fi

tail -n +2 "$MANIFEST" | while IFS=$'\t' read -r path origin branch status; do
    full_path="$HOME/$path"
    if [ -d "$full_path/.git" ]; then
        echo "✅ Repo already exists at $full_path. Skipping."
    else
        if [ "$origin" != "no-remote" ]; then
            echo "🔄 Cloning $origin to $full_path..."
            git clone --branch "$branch" "$origin" "$full_path"
        else
            echo "⚠️  No remote for $full_path. Creating empty repo..."
            mkdir -p "$full_path"
            git -C "$full_path" init
        fi
    fi
done