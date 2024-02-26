#!/usr/bin/env bash

set -euo pipefail

chosen="$(echo -e "🔌local\n\
🔊dock\n\
🎧sony\n\
📢boombox\n\
🎧openheadphones(laptop)" | rofi -dmenu -p "🎶 [M]usic and 🎤 Switch")"

function b {
	BOOMBOX="bluez_sink.04_21_44_B6_92_39.a2dp_sink"
	echo -e 'power on\nquit' | bluetoothctl
	sleep 2
	echo -e 'connect 04:21:44:B6:92:39\nquit' | bluetoothctl
	sleep 10
	pactl set-default-sink "$BOOMBOX"
	INPUTS=$(pactl list sink-inputs short | cut -f 1)
	for i in $INPUTS; do
		pactl move-sink-input "$i" "$BOOMBOX"
	done
}

function d {
	DOCK="alsa_output.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.analog-stereo"

	pactl set-default-sink "$DOCK"
	INPUTS=$(pactl list sink-inputs short | cut -f 1)
	for i in $INPUTS; do
		pactl move-sink-input "$i" "$DOCK"
	done
}

function l {
	LOCALSPEAKER1="alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0003.hw_sofsoundwire_2__sink"
	LOCALSPEAKER2="alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0005.hw_sofsoundwire_2__sink"
	LOCALSPEAKER3="alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0007.hw_sofsoundwire_2__sink"
	LOCALSPEAKER4="alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_2__sink"
	LOCALSPEAKER5="alsa_output.pci-0000_00_1f.3.analog-stereo"
	SINKS=$(pactl list sinks)

	LOCALMIKE1="alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0003.hw_sofsoundwire_4__source"
	LOCALMIKE2="alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0005.hw_sofsoundwire_4__source"
	LOCALMIKE3="alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0007.hw_sofsoundwire_4__source"
	LOCALMIKE4="alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_4__source"
	LOCALMIKE5="alsa_input.usb-C-Media_Electronics_Inc._USB_PnP_Audio_Device-00.mono-fallback"
	LOCALMIKE6="alsa_input.usb-Generic_Blue_Microphones_LT_221104181411AD020101_111000-00.analog-stereo"
	SOURCES=$(pactl list sources)

	case $SINKS in
	*"$LOCALSPEAKER1"*) LOCALSPEAKER=$LOCALSPEAKER1 ;;
	*"$LOCALSPEAKER2"*) LOCALSPEAKER=$LOCALSPEAKER2 ;;
	*"$LOCALSPEAKER3"*) LOCALSPEAKER=$LOCALSPEAKER3 ;;
	*"$LOCALSPEAKER4"*) LOCALSPEAKER=$LOCALSPEAKER4 ;;
	*"$LOCALSPEAKER5"*) LOCALSPEAKER=$LOCALSPEAKER5 ;;
	*) echo "Local speaker not found" ;;
	esac

	case $SOURCES in
	*"$LOCALMIKE1"*) LOCALMIKE=$LOCALMIKE1 ;;
	*"$LOCALMIKE2"*) LOCALMIKE=$LOCALMIKE2 ;;
	*"$LOCALMIKE3"*) LOCALMIKE=$LOCALMIKE3 ;;
	*"$LOCALMIKE4"*) LOCALMIKE=$LOCALMIKE4 ;;
	*"$LOCALMIKE5"*) LOCALMIKE=$LOCALMIKE5 ;;
	*"$LOCALMIKE6"*) LOCALMIKE=$LOCALMIKE6 ;;
	*) echo "Local mike not found" ;;
	esac

	pactl set-default-sink "$LOCALSPEAKER"
	INPUTS=$(pactl list sink-inputs short | cut -f 1)
	for i in $INPUTS; do
		pactl move-sink-input "$i" "$LOCALSPEAKER"
	done

	pactl set-default-source "$LOCALMIKE"
	OUTPUTS=$(pactl list source-outputs short | cut -f 1)
	for i in $OUTPUTS; do
		pactl move-source-output "$i" "$LOCALMIKE"
	done
}

function s {
	HEADSET="bluez_sink.14_3F_A6_28_DC_51.a2dp_sink"
	echo -e 'power on\nquit' | bluetoothctl
	sleep 2
	echo -e 'connect 14:3F:A6:28:DC:51\nquit' | bluetoothctl
	sleep 5
	pactl set-default-sink "$HEADSET"
	INPUTS=$(pactl list sink-inputs short | cut -f 1)
	for i in $INPUTS; do
		pactl move-sink-input "$i" "$HEADSET"
	done
}

function o {
	OPENHEADSET="alsa_output.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH84440324JKLTA7-00.analog-stereo"
	SINKS=$(pactl list sinks)

	OPENHEADSETMIKE="alsa_input.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH84440324JKLTA7-00.mono-fallback"
	SOURCES=$(pactl list sources)

	pactl set-default-sink $OPENHEADSET
	INPUTS=$(pactl list sink-inputs short | cut -f 1)
	for i in $INPUTS; do
		pactl move-sink-input "$i" $OPENHEADSET
	done

	pactl set-default-source $OPENHEADSETMIKE
	OUTPUTS=$(pactl list source-outputs short | cut -f 1)
	for i in $OUTPUTS; do
		pactl move-source-output "$i" $OPENHEADSETMIKE
	done
}

case "$chosen" in
🔌local) l ;;
🔊dock) d ;;
🎧sony) s ;;
📢boombox) b ;;
"🎧openheadphones(laptop)") o ;;
*) exit 1 ;;
esac
