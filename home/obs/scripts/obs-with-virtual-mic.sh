#!/usr/bin/env bash
set -euo pipefail

# Enable xtrace when debugging
if [ "${OBS_VMIC_DEBUG:-0}" = "1" ]; then
  set -x
fi

log() {
  printf '%s %s\n' "[obs-vmic]" "$*" >&2
}

get_source_id_by_name() {
  # Return numeric ID for a Source line matching the provided name
  # Example line: "163. ObsMic Audio/Source/Virtual sink    [vol: 1.00]"
  local name
  name="$1"
  wpctl status \
    | sed -n '/Sources:/,/Sinks:/p' \
    | grep --fixed-strings "$name" \
    | sed -n 's/^[^0-9]*\([0-9]\+\)\..*/\1/p' \
    | head --lines=1
}

get_default_source_star() {
  # Return the numeric ID that currently has the star in Sources
  wpctl status \
    | sed -n '/Sources:/,/Sinks:/p' \
    | sed -n 's/^.*\*[^0-9]*\([0-9]\+\)\. .*/\1/p' \
    | head --lines=1
}

set_default_source_id() {
  local id
  id="$1"
  log "Setting default Source to ID=$id"
  wpctl set-default "$id"
}

main() {
  # Capture current default (by star) so we can restore later
  local prev_id
  prev_id="$(get_default_source_star || true)"
  log "Previous default Source (star) ID: ${prev_id:-<none>}"

  restore_default() {
    if [ -n "${prev_id:-}" ]; then
      log "Restoring previous default Source ID: $prev_id"
      wpctl set-default "$prev_id" || true
    fi
  }
  trap restore_default EXIT INT TERM

  # Try to locate the OBS virtual mic quickly (max 2 seconds)
  local patterns target_id
  patterns=$(cat <<'EOF'
ObsMic Audio/Source/Virtual sink
ObsMic
OBS Virtual Microphone
OBS Virtual Mic
VirtualMic
Virtual Microphone
EOF
)

  target_id=""
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    while read -r nm; do
      [ -z "$nm" ] && continue
      target_id="$(get_source_id_by_name "$nm" || true)"
      if [ -n "$target_id" ]; then
        break
      fi
    done <<<"$patterns"
    [ -n "$target_id" ] && break
    sleep 0.2
  done

  if [ -n "$target_id" ]; then
    set_default_source_id "$target_id" || true
    # Reassert briefly to handle races
    for _ in 1 2 3 4 5; do
      cur="$(get_default_source_star || true)"
      [ "$cur" = "$target_id" ] && break
      log "Reasserting default to $target_id (current=$cur)"
      wpctl set-default "$target_id" || true
      sleep 0.2
    done
    cur="$(get_default_source_star || true)"
    log "Final default Source (star) ID: ${cur:-<unknown>}"
  else
    log "Virtual mic not found within 2s; continuing without switching"
  fi

  # Launch OBS (replace wrapper process)
  exec obs "$@"
}

main "$@"
