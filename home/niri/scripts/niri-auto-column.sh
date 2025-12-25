#!/usr/bin/env bash

# Auto-consume windows into columns on vertical monitors
# Listens to niri event stream and consumes new windows on specified outputs

set -euo pipefail

# Outputs where windows should auto-stack into columns
VERTICAL_OUTPUTS=("HDMI-A-2" "HDMI-A-1")

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

get_column_window_count() {
  local window_id="$1"
  # Get the focused window's column info from the layout
  niri msg --json windows | jq --argjson id "$window_id" '
    [.[] | select(.workspace_id == (.[] | select(.id == $id) | .workspace_id))] | length
  ' 2>/dev/null || echo "1"
}

# Main event loop
niri msg --json event-stream | while IFS= read -r event; do
  event_type=$(echo "$event" | jq -r 'keys[0]')

  if [[ "$event_type" == "WindowOpenedOrChanged" ]]; then
    window=$(echo "$event" | jq '.WindowOpenedOrChanged.window')
    window_id=$(echo "$window" | jq -r '.id')
    workspace_id=$(echo "$window" | jq -r '.workspace_id // empty')
    is_focused=$(echo "$window" | jq -r '.is_focused')

    # Skip if no workspace (floating or special windows)
    if [[ -z "$workspace_id" || "$workspace_id" == "null" ]]; then
      continue
    fi

    # Get the output for this workspace
    output=$(get_workspace_output "$workspace_id")

    if [[ -z "$output" ]]; then
      continue
    fi

    # Check if this is a vertical output
    if is_vertical_output "$output"; then
      # Only act on focused windows (newly opened windows get focus)
      if [[ "$is_focused" == "true" ]]; then
        # Small delay to let niri finish placing the window
        sleep 0.05
        # Move focus to the left column, then consume the new window from the right
        niri msg action focus-column-left 2>/dev/null || true
        niri msg action consume-window-into-column 2>/dev/null || true
      fi
    fi
  fi
done
