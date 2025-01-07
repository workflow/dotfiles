set -euo pipefail

chosen="$(echo -e "🔌local\n\
🎧oh(localmic)
🎧🎙️oh(ohmic)
🎧sony\n\
 budsFE(listen)\n\
 budsFE(talk)\n\
 buds(listen)\n\
 buds(talk)\n\
📢boombox\n\
" | rofi -dmenu -p "🎶 [M]usic and 🎤 Switch")"

localspeaker() {
	local card_name_pattern="00_1f"
	local potential_sinks=(
		"alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0003.hw_sofsoundwire_2__sink"
		"alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0005.hw_sofsoundwire_2__sink"
		"alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0007.hw_sofsoundwire_2__sink"
		"alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_2__sink"
		"alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__Speaker__sink"
		"alsa_output.pci-0000_00_1f.3.analog-stereo"
		"alsa_output.pci-0000_00_1f.3.analog-stereo.2"
	)
	local actual_sinks
	local selected_sink
	local card_profile="HiFi"

	actual_sinks=$(pactl list sinks)
	for source in "${potential_sinks[@]}"; do
		if [[ "$actual_sinks" == *"$source"* ]]; then
			selected_sink=$source
			break
		fi
	done

	if [ -z "$selected_sink" ]; then
		echo "Local speaker not found"
		return 1
	fi

	set_default_sink "$card_name_pattern" "$selected_sink" "$card_profile"

	localmike
}

ohlocalmic() {
	local card_name_pattern="Apple"
	local sink="alsa_output.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH84440324JKLTA7-00.analog-stereo"
	local card_profile="HiFi"

	set_default_sink "$card_name_pattern" "$sink" "$card_profile"

	localmike
}

ohohmic() {
	local card_name_pattern="Apple"
	local sink="alsa_output.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH84440324JKLTA7-00.analog-stereo"
	local card_profile="?"

	set_default_sink "$card_name_pattern" "$sink" "$card_profile"

	ohmike
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

	set_default_sink "$card_name_pattern" "$sink" "$card_profile"

	localmike
}

budsfelisten() {
	local card_name_pattern="34_E3"
	local sink="bluez_output.34_E3_FB_C5_01_E0.1"
	local card_profile="a2dp-sink-sbc"

	set_default_sink "$card_name_pattern" "$sink" "$card_profile"

	localmike
}

budsfetalk() {
	local card_name_pattern="34_E3"
	local sink="bluez_output.34_E3_FB_C5_01_E0.1"
	local card_profile="headset-head-unit-msbc"

	set_default_sink "$card_name_pattern" "$sink" "$card_profile"

	budsfemike
}

budslisten() {
	local card_name_pattern="DC_69"
	local sink="bluez_output.DC_69_E2_9A_6E_30.1"
	local card_profile="a2dp-sink-sbc"

	set_default_sink "$card_name_pattern" "$sink" "$card_profile"

	localmike
}

budstalk() {
	local card_name_pattern="DC_69"
	local sink="bluez_output.DC_69_E2_9A_6E_30.1"
	local card_profile="headset-head-unit-msbc"

	set_default_sink "$card_name_pattern" "$sink" "$card_profile"

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

	set_default_sink "$card_name_pattern" "$sink" "$card_profile"

	localmike
}

localmike() {
	local card_name_pattern="00_1f"
	local potential_sources=(
		"alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0003.hw_sofsoundwire_4__source"
		"alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0005.hw_sofsoundwire_4__source"
		"alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0007.hw_sofsoundwire_4__source"
		"alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_4__source"
		"alsa_input.usb-C-Media_Electronics_Inc._USB_PnP_Audio_Device-00.mono-fallback"
		"alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi__Mic__source"
	)
	local actual_sources
	local selected_source
	local card_profile="HiFi"

	actual_sources=$(pactl list sources)
	for source in "${potential_sources[@]}"; do
		if [[ "$actual_sources" == *"$source"* ]]; then
			selected_source=$source
			break
		fi
	done

	if [ -z "$selected_source" ]; then
		echo "Local mike not found"
		return 1
	fi

	set_default_source "$card_name_pattern" "$selected_source" "$card_profile"
}

ohmike() {
	local card_name_pattern="Apple"
	local source="alsa_input.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH84440324JKLTA7-00.mono-fallback"
	local card_profile="?"

	set_default_source "$card_name_pattern" "$source" "$card_profile"
}

budsfemike() {
	local card_name_pattern="34_E3"
	local source="bluez_input_internal.34_E3_FB_C5_01_E0.0"
	local card_profile="headset-head-unit-msbc"

	set_default_source "$card_name_pattern" "$source" "$card_profile"
}

budsmike() {
	local card_name_pattern="DC_69"
	local source="bluez_input.DC:69:E2:9A:6E:30"
	local card_profile="headset-head-unit-msbc"

	set_default_source "$card_name_pattern" "$source" "$card_profile"
}

get_card_id() {
	local card_name_pattern="$1"
	nu -c "pactl list cards short | lines | parse \"{id}\t{name}\t{_}\" | where \$it.name =~ \"$card_name_pattern\" | get id  | get 0" || true
}

set_default_sink() {
	local card_name_pattern="$1"
	local sink="$2"
	local card_profile="$3"

	local card_id
	card_id=$(get_card_id "$card_name_pattern")

	pactl set-card-profile "$card_id" "$card_profile"
	pactl set-default-sink "$sink"
}

set_default_source() {
	local card_name_pattern="$1"
	local source="$2"
	local card_profile="$3"

	local card_id
	card_id=$(get_card_id "$card_name_pattern")

	pactl set-card-profile "$card_id" "$card_profile"
	pactl set-default-source "$source"
}

connect_bluetooth() {
	local bd_address="$1"

	echo -e 'power on\nquit' | bluetoothctl
	sleep 2
	echo -e "connect $bd_address\nquit" | bluetoothctl
	sleep 10
}

case "$chosen" in
🔌local) localspeaker ;;
"🎧oh(localmic)") ohlocalmic ;;
"🎧🎙️oh(ohmic)") ohohmic ;;
🎧sony) ohohmic ;;
" budsFE(listen)") budsfelisten ;;
" budsFE(talk)") budsfetalk ;;
" buds(listen)") budslisten ;;
" buds(talk)") budstalk ;;
📢boombox) boombox ;;
*) exit 1 ;;
esac
