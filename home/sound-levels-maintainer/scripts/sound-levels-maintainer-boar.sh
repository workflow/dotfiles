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

wpctl set-volume "$OBS_SPEAKER_ID" 1.0
wpctl set-volume "$OBS_MIC_ID" 1.0

while true; do
	current_volume_obs_speaker=$(wpctl get-volume "$OBS_SPEAKER_ID" | awk '{print $2}')
	current_volume_obs_mic=$(wpctl get-volume "$OBS_MIC_ID" | awk '{print $2}')

	[ "$current_volume_obs_speaker" != "1.0" ] && wpctl set-volume "$OBS_SPEAKER_ID" 1.0
	[ "$current_volume_obs_mic" != "1.0" ] && wpctl set-volume "$OBS_MIC_ID" 1.0

	sleep 1
done
