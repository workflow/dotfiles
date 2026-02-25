#!/usr/bin/env bash

# Auto-consume windows into columns on vertical monitors
# Listens to niri event stream and consumes new windows on specified outputs.
# Tracks known window IDs so that focus-change events (e.g. after a window
# closes) don't re-trigger the consume logic.

set -euo pipefail

VERTICAL_OUTPUTS=("HDMI-A-2" "HDMI-A-1")
declare -A KNOWN_WINDOWS

get_workspace_output() {
  local workspace_id="$1"
  niri msg --json workspaces | jq -r --argjson id "$workspace_id" \
    '.[] | select(.id == $id) | .output // empty'
}

is_vertical_output() {
  local output="$1"
  for v in "${VERTICAL_OUTPUTS[@]}"; do
    if [[ "$output" == "$v" ]]; then
      return 0
    fi
  done
  return 1
}

consume_into_column() {
  sleep 0.05
  niri msg action focus-column-left 2>/dev/null || true
  niri msg action consume-window-into-column 2>/dev/null || true
  niri msg action focus-window-down 2>/dev/null || true
}

# Use process substitution so the loop runs in the main shell,
# allowing the KNOWN_WINDOWS associative array to persist across iterations.
while IFS= read -r event; do
  event_type=$(echo "$event" | jq -r 'keys[0]')

  if [[ "$event_type" == "WindowClosed" ]]; then
    closed_id=$(echo "$event" | jq -r '.WindowClosed.id')
    unset "KNOWN_WINDOWS[$closed_id]"
    continue
  fi

  if [[ "$event_type" != "WindowOpenedOrChanged" ]]; then
    continue
  fi

  window=$(echo "$event" | jq '.WindowOpenedOrChanged.window')
  window_id=$(echo "$window" | jq -r '.id')

  # Skip windows we've already seen (focus changes, title changes, etc.)
  if [[ -v "KNOWN_WINDOWS[$window_id]" ]]; then
    continue
  fi
  KNOWN_WINDOWS[$window_id]=1

  workspace_id=$(echo "$window" | jq -r '.workspace_id // empty')
  is_focused=$(echo "$window" | jq -r '.is_focused')

  if [[ -z "$workspace_id" || "$workspace_id" == "null" ]]; then
    continue
  fi

  output=$(get_workspace_output "$workspace_id")
  if [[ -z "$output" ]]; then
    continue
  fi

  if is_vertical_output "$output" && [[ "$is_focused" == "true" ]]; then
    consume_into_column
  fi
done < <(niri msg --json event-stream)
