set -euo pipefail

# Create a virtual sink that can be set as a monitor in OBS
if ! pactl list short sinks | grep -q ObsSpeaker; then
	pactl load-module module-null-sink \
		sink_name=ObsSpeaker \
		sink_properties=device.description=VirtualSpeaker \
		channel_map=front-left,front-right
fi

# Expose ObsSpeaker.monitor as a named source so it shows up as a regular mic
# in pulseaudio apps like Zoom/Signal. Using remap-source (instead of a second
# null-sink bridged with pw-link) keeps clock and buffer shared with the
# master, avoiding latency accumulation when consumers pick a large quantum.
if ! pactl list short sources | grep -q ObsMic; then
	pactl load-module module-remap-source \
		master=ObsSpeaker.monitor \
		source_name=ObsMic \
		source_properties=device.description=VirtualMic \
		channel_map=front-left,front-right \
		master_channel_map=front-left,front-right
fi
