set -euo pipefail

get_pipewire_node_id() {
	local node_name="$1"
	pw-cli ls Node | awk -v name="$node_name" '
    $1 == "id" { id=$2 }
    /node.name/ && $3 == "\"" name "\"" { gsub(/,/, "", id); print id }
    '
}

OBS_SPEAKER_ID=$(get_pipewire_node_id "ObsSpeaker")
OBS_MIC_ID=$(get_pipewire_node_id "ObsMic")
INTERNAL_MIC_ID=$(get_pipewire_node_id "alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi__Mic__source")
BUDS_PRO_MIC_ID=$(get_pipewire_node_id "bluez_input.DC_69_E2_9A_6E_30.0")
BUDS_FE_MIC_ID=$(get_pipewire_node_id "bluez_input_internal.34_E3_FB_C5_01_E0.0")
OH_MIC_ID=$(get_pipewire_node_id "alsa_input.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH84440324JKLTA7-00.mono-fallback")

wpctl set-volume "$OBS_SPEAKER_ID" 1.0
wpctl set-volume "$OBS_MIC_ID" 1.0
wpctl set-volume "$INTERNAL_MIC_ID" 2.0
if [ -n "$OH_MIC_ID" ]; then
	wpctl set-volume "$OH_MIC_ID" 0.75
fi
if [ -n "$BUDS_PRO_MIC_ID" ]; then
	wpctl set-volume "$BUDS_PRO_MIC_ID" 1.0
fi
if [ -n "$BUDS_FE_MIC_ID" ]; then
	wpctl set-volume "$BUDS_FE_MIC_ID" 0.9
fi

while true; do
	current_volume_obs_speaker=$(wpctl get-volume "$OBS_SPEAKER_ID" | awk '{print $2}')
	current_volume_obs_mic=$(wpctl get-volume "$OBS_MIC_ID" | awk '{print $2}')
	current_volume_internal_mic=$(wpctl get-volume "$INTERNAL_MIC_ID" | awk '{print $2}')

	[ "$current_volume_obs_speaker" != "1.0" ] && wpctl set-volume "$OBS_SPEAKER_ID" 1.0
	[ "$current_volume_obs_mic" != "1.0" ] && wpctl set-volume "$OBS_MIC_ID" 1.0
	[ "$current_volume_internal_mic" != "2.0" ] && wpctl set-volume "$INTERNAL_MIC_ID" 2.0

	if [ -n "$BUDS_PRO_MIC_ID" ]; then
		current_volume_buds_pro_mic=$(wpctl get-volume "$BUDS_PRO_MIC_ID" | awk '{print $2}')
		[ "$current_volume_buds_pro_mic" != "1.0" ] && wpctl set-volume "$BUDS_PRO_MIC_ID" 1.0
	fi
	if [ -n "$BUDS_FE_MIC_ID" ]; then
		current_volume_buds_fe_mic=$(wpctl get-volume "$BUDS_FE_MIC_ID" | awk '{print $2}')
		[ "$current_volume_buds_fe_mic" != "0.9" ] && wpctl set-volume "$BUDS_FE_MIC_ID" 0.9
	fi
	if [ -n "$OH_MIC_ID" ]; then
		current_volume_oh_mic=$(wpctl get-volume "$OH_MIC_ID" | awk '{print $2}')
		[ "$current_volume_oh_mic" != "0.75" ] && wpctl set-volume "$OH_MIC_ID" 0.75
	fi

	sleep 1
done
