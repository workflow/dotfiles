#!/usr/bin/env bash
# Opens a command and moves its window to a specific workspace once the title matches

set -euo pipefail

workspace="$1"
title_pattern="$2"
shift 2

# Launch the command in background
"$@" &

# Wait for window with matching title to appear (max 30 seconds)
for _ in {1..60}; do
    sleep 0.5
    window_id=$(niri msg -j windows | jq -r ".[] | select(.title | test(\"$title_pattern\")) | .id" | head -n1)
    if [[ -n "$window_id" ]]; then
        niri msg action move-window-to-workspace --window-id "$window_id" "$workspace"
        exit 0
    fi
done

echo "Timeout waiting for window with title matching: $title_pattern" >&2
exit 1
