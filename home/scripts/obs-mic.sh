#!/usr/bin/env bash

set -euo pipefail

# Create a virtual sink that can be set as a monitor in OBS
pactl load-module module-null-sink sink_name=ObsSpeaker sink_properties=device.description=VirtualSpeaker

# Link it with a virtual source that is visible in pulseaudio apps like Zoom
pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=ObsMic channel_map=front-left,front-right
pw-link ObsSpeaker:monitor_FL ObsMic:input_FL
pw-link ObsSpeaker:monitor_FR ObsMic:input_FR
