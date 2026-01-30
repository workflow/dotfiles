#!/usr/bin/env bash

# Script to reorder Niri workspaces based on their names
# This ensures workspaces maintain their logical order even after being moved between monitors

set -euo pipefail

# Define the desired workspace order
declare -A WORKSPACE_ORDER=(
  [" a"]=0
  [" 1"]=1
  [" 2"]=2
  [" 3"]=3
  [" 4"]=4
  [" 5"]=5
  [" 6"]=6
  [" 7"]=7
  [" 8"]=8
  [" 9"]=9
  [" 10"]=10
)

# Get all workspaces as JSON
workspaces_json=$(niri msg --json workspaces)

# Get unique output names
outputs=$(echo "$workspaces_json" | jq -r '.[].output' | sort -u)

# For each output/monitor
while IFS= read -r output; do
  # Get workspaces on this output with their current indices and names
  workspace_data=$(echo "$workspaces_json" | jq -r \
    --arg output "$output" \
    '.[] | select(.output == $output) | "\(.idx)|\(.name)"')

  # Build an array of workspaces with their sort order
  declare -a workspace_list=()

  while IFS='|' read -r current_idx name; do
    # Look up the desired order for this workspace name
    if [[ -v WORKSPACE_ORDER["$name"] ]]; then
      sort_order="${WORKSPACE_ORDER[$name]}"
      # Store as: sort_order|current_idx|name
      workspace_list+=("$sort_order|$current_idx|$name")
    fi
  done <<<"$workspace_data"

  # Sort workspaces by their logical order (first field)
  mapfile -t sorted_workspaces < <(printf '%s\n' "${workspace_list[@]}" | sort -t'|' -k1 -n)

  # Assign sequential target indices (forward iteration)
  for ((i = 0; i < ${#sorted_workspaces[@]}; i++)); do
    target_indices[i]=$i
  done

  # Move workspaces to their target positions (backward iteration to avoid displacement)
  for ((i = ${#sorted_workspaces[@]} - 1; i >= 0; i--)); do
    IFS='|' read -r sort_order current_idx name <<<"${sorted_workspaces[$i]}"
    target_idx=${target_indices[i]}

    if [[ "$current_idx" != "$target_idx" ]]; then
      # Focus the workspace by name first
      niri msg action focus-workspace "$name" >/dev/null 2>&1 || true

      # Move it to the correct index
      niri msg action move-workspace-to-index "$target_idx" >/dev/null 2>&1 || true
    fi
  done

  # Clear arrays for the next output
  unset workspace_list
  unset sorted_workspaces
  unset target_indices
done <<<"$outputs"

echo "Workspaces reordered successfully!"
