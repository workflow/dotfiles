set -euo pipefail

chosen="$(echo -e "🎧oh\n\
🔊creative\n\
🎧sony\n\
 buds(listen)\n\
 buds(talk)\n\
📢boombox\n\
" | rofi -dmenu -p "🎶 [M]usic and 🎤 Switch")"

oh() {
	local card_name_pattern="51_00"
	local sink="alsa_output.pci-0000_51_00.1.hdmi-stereo.2"
	local card_profile="output:hdmi-stereo"

	set_default_sink_and_move_inputs "$card_name_pattern" "$sink" "$card_profile"

	localmike
}

creative() {
	local card_name_pattern="51_00"
	local sink="alsa_output.pci-0000_51_00.1.hdmi-stereo-extra1"
	local card_profile="output:hdmi-stereo-extra1"

	set_default_sink_and_move_inputs "$card_name_pattern" "$sink" "$card_profile"

	localmike
}

boombox() {
	local card_name_pattern="04_21"
	local sink="bluez_sink.04_21_44_B6_92_39.a2dp_sink"
	local card_profile="?"

	local bd_address="04:21:44:B6:92:39"
	local card_id
	if [[ -z $card_id ]]; then
		connect_bluetooth "$bd_address"
	fi

	set_default_sink_and_move_inputs "$card_name_pattern" "$sink" "$card_profile"

	localmike
}

budslisten() {
	local card_name_pattern="DC_69"
	local sink="bluez_output.DC_69_E2_9A_6E_30.1"
	local card_profile="a2dp-sink-sbc"

	set_default_sink_and_move_inputs "$card_name_pattern" "$sink" "$card_profile"

	localmike
}

budstalk() {
	local card_name_pattern="DC_69"
	local sink="bluez_output.DC_69_E2_9A_6E_30.1"
	local card_profile="headset-head-unit-msbc"

	set_default_sink_and_move_inputs "$card_name_pattern" "$sink" "$card_profile"

	budsmike
}

sony() {
	local card_name_pattern="14_3F"
	local sink="bluez_output.14_3F_A6_28_DC_51.1"
	local card_profile="a2dp-sink-sbc"

	local bd_address="14:3F:A6:28:DC:51"
	local card_id
	card_id=$(get_card_id "$card_name_pattern")
	if [[ -z $card_id ]]; then
		connect_bluetooth "$bd_address"
	fi

	set_default_sink_and_move_inputs "$card_name_pattern" "$sink" "$card_profile"

	localmike
}

localmike() {
	LOCALMIKE1="alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0003.hw_sofsoundwire_4__source"
	LOCALMIKE2="alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0005.hw_sofsoundwire_4__source"
	LOCALMIKE3="alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0007.hw_sofsoundwire_4__source"
	LOCALMIKE4="alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_4__source"
	LOCALMIKE5="alsa_input.usb-C-Media_Electronics_Inc._USB_PnP_Audio_Device-00.mono-fallback"
	LOCALMIKE6="alsa_input.usb-Generic_Blue_Microphones_LT_221104181411AD020101_111000-00.analog-stereo"
	SOURCES=$(pactl list sources)

	case $SOURCES in
	*"$LOCALMIKE1"*) LOCALMIKE=$LOCALMIKE1 ;;
	*"$LOCALMIKE2"*) LOCALMIKE=$LOCALMIKE2 ;;
	*"$LOCALMIKE3"*) LOCALMIKE=$LOCALMIKE3 ;;
	*"$LOCALMIKE4"*) LOCALMIKE=$LOCALMIKE4 ;;
	*"$LOCALMIKE5"*) LOCALMIKE=$LOCALMIKE5 ;;
	*"$LOCALMIKE6"*) LOCALMIKE=$LOCALMIKE6 ;;
	*) echo "Local mike not found" ;;
	esac

	pactl set-default-source "$LOCALMIKE"
	OUTPUTS=$(pactl list source-outputs short | cut -f 1)
	for i in $OUTPUTS; do
		pactl move-source-output "$i" "$LOCALMIKE"
	done
}

budsmike() {
	BUDSMIKE="bluez_input.DC:69:E2:9A:6E:30"
	SOURCES=$(pactl list sources)

	pactl set-default-source "$BUDSMIKE"
	OUTPUTS=$(pactl list source-outputs short | cut -f 1)
	for i in $OUTPUTS; do
		pactl move-source-output "$i" "$BUDSMIKE"
	done
}

get_card_id() {
	local card_name_pattern="$1"
	nu -c "pactl list cards short | lines | parse \"{id}\t{name}\t{_}\" | where \$it.name =~ \"$card_name_pattern\" | get id  | get 0" || true
}

set_default_sink_and_move_inputs() {
	local card_name_pattern="$1"
	local sink="$2"
	local card_profile="$3"

	local card_id
	card_id=$(get_card_id "$card_name_pattern")

	pactl set-card-profile "$card_id" "$card_profile"
	pactl set-default-sink "$sink"
	local inputs
	inputs=$(pactl list sink-inputs short | cut -f 1)
	for i in $inputs; do
		pactl move-sink-input "$i" "$sink"
	done
}

connect_bluetooth() {
	local bd_address="$1"

	echo -e 'power on\nquit' | bluetoothctl
	sleep 2
	echo -e "connect $bd_address\nquit" | bluetoothctl
	sleep 10
}

case "$chosen" in
🎧oh) oh ;;
🔊creative) creative ;;
🎧sony) sony ;;
" buds(listen)") budslisten ;;
" buds(talk)") budstalk ;;
📢boombox) boombox ;;
*) exit 1 ;;
esac
