#!/usr/bin/env bash
set -euo pipefail

log() {
	printf '%s %s\n' "[obs-mic]" "$*" >&2
}

list_ports() {
	# Prefer longhand; fall back to short if needed
	if ! pw-link --list >/dev/null 2>&1; then
		pw-link -l
		return 0
	fi
	pw-link --list
}

has_port() {
	local port
	port="$1"
	list_ports | grep --fixed-strings --quiet -- "$port"
}

wait_for_port() {
	local port timeout
	port="$1"
	timeout="${2:-10}"
	for _ in $(seq 1 $((timeout * 10))); do
		if has_port "$port"; then
			return 0
		fi
		sleep 0.1
	done
	return 1
}

# Create a virtual sink that can be set as a monitor in OBS
if ! pactl list short sinks | grep --quiet -- "ObsSpeaker"; then
	log "Loading ObsSpeaker (module-null-sink)"
	pactl load-module module-null-sink sink_name=ObsSpeaker sink_properties=device.description=VirtualSpeaker || true
fi

# Create a virtual source that apps can select as microphone (eligible as default)
if ! pactl list short sources | grep --quiet -- "ObsMic"; then
	log "Loading ObsMic (module-null-sink as Audio/Source)"
	pactl load-module module-null-sink media.class=Audio/Source sink_name=ObsMic channel_map=front-left,front-right || true
fi

# Wait for the ports to appear, then link monitor -> virtual mic inputs
log "Waiting for ports to appear..."
wait_for_port "ObsSpeaker:monitor_FL" 15 || log "Port not found yet: ObsSpeaker:monitor_FL"
wait_for_port "ObsSpeaker:monitor_FR" 15 || log "Port not found yet: ObsSpeaker:monitor_FR"
wait_for_port "ObsMic:input_FL" 15 || log "Port not found yet: ObsMic:input_FL"
wait_for_port "ObsMic:input_FR" 15 || log "Port not found yet: ObsMic:input_FR"

# Try linking (ignore errors if ports are missing or links already exist)
if has_port "ObsSpeaker:monitor_FL" && has_port "ObsMic:input_FL"; then
	log "Linking FL: ObsSpeaker:monitor_FL -> ObsMic:input_FL"
	pw-link "ObsSpeaker:monitor_FL" "ObsMic:input_FL" || true
fi
if has_port "ObsSpeaker:monitor_FR" && has_port "ObsMic:input_FR"; then
	log "Linking FR: ObsSpeaker:monitor_FR -> ObsMic:input_FR"
	pw-link "ObsSpeaker:monitor_FR" "ObsMic:input_FR" || true
fi

log "obs-mic setup completed"
