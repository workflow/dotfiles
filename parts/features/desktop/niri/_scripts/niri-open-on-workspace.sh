#!/usr/bin/env bash
# Opens a command and moves its window to a specific workspace once the title matches.
# If a window with the matching title already exists (e.g. from session restore), just moves it
# instead of spawning a duplicate.

set -euo pipefail

workspace="$1"
title_pattern="$2"
shift 2

spawned=false

# Poll for up to 30 seconds. Wait a bit before spawning to give session restore
# a chance to recreate windows first.
for i in {1..60}; do
    sleep 0.5
    window_id=$(niri msg -j windows | jq -r ".[] | select(.title | test(\"$title_pattern\")) | .id" | head -n1)
    if [[ -n "$window_id" ]]; then
        niri msg action move-window-to-workspace --window-id "$window_id" "$workspace"
        exit 0
    fi

    # After 5 seconds with no match, assume session restore won't provide one
    if [[ "$i" -eq 10 ]] && [[ "$spawned" == false ]]; then
        "$@" &
        spawned=true
    fi
done

echo "Timeout waiting for window with title matching: $title_pattern" >&2
exit 1
