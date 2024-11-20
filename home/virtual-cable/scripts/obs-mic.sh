set -euo pipefail

# Create a virtual sink that can be set as a monitor in OBS
if ! pactl list short sinks | grep -q ObsSpeaker; then
	pactl load-module module-null-sink sink_name=ObsSpeaker sink_properties=device.description=VirtualSpeaker
fi

# Link it with a virtual source that is visible in pulseaudio apps like Zoom
if ! pactl list short sources | grep -q ObsMic; then
	pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=ObsMic channel_map=front-left,front-right
	pw-link ObsSpeaker:monitor_FL ObsMic:input_FL
	pw-link ObsSpeaker:monitor_FR ObsMic:input_FR
fi
