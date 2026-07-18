#!/usr/bin/env bash
# Opens a command and moves its window to a specific workspace once the title matches.
# If a window with the matching title already exists (e.g. from session restore), just moves it
# instead of spawning a duplicate.
#
# --after-app-id PATTERN: delay spawning until a window with a matching app-id exists, so the
# command opens via remoting into the running instance. Without this, two invocations cold-start
# the same browser profile simultaneously and the race leaves a spurious extra window. Falls
# back to spawning anyway after 15 seconds in case the first instance never shows up.

set -euo pipefail

after_app_id=""
if [[ "${1:-}" == "--after-app-id" ]]; then
    after_app_id="$2"
    shift 2
fi

workspace="$1"
title_pattern="$2"
shift 2

spawned=false

find_window_by_title() {
    niri msg -j windows | jq -r --arg re "$title_pattern" '.[] | select(.title | test($re)) | .id' | head -n1
}

app_is_running() {
    [[ -z "$after_app_id" ]] ||
        niri msg -j windows | jq -e --arg re "$after_app_id" 'any(.[]; (.app_id // "") | test($re))' >/dev/null
}

spawn_is_due() {
    local tick="$1"
    if [[ "$tick" -ge 30 ]]; then
        return 0
    fi
    [[ "$tick" -ge 10 ]] && app_is_running
}

# Poll for up to 30 seconds. Wait a bit before spawning to give session restore
# a chance to recreate windows first.
for i in {1..60}; do
    sleep 0.5
    window_id=$(find_window_by_title)
    if [[ -n "$window_id" ]]; then
        niri msg action move-window-to-workspace --window-id "$window_id" "$workspace"
        exit 0
    fi

    if [[ "$spawned" == false ]] && spawn_is_due "$i"; then
        "$@" &
        spawned=true
    fi
done

echo "Timeout waiting for window with title matching: $title_pattern" >&2
exit 1
