set -euo pipefail

VIRTUAL_SPEAKER_ID=86
OBS_MIC_ID=92

wpctl set-volume $VIRTUAL_SPEAKER_ID 1.0
wpctl set-volume $OBS_MIC_ID 1.0

while true; do
	current_volume_virtual_speaker=$(wpctl get-volume $VIRTUAL_SPEAKER_ID | awk '{print $2}')
	current_volume_obs_mic=$(wpctl get-volume $OBS_MIC_ID | awk '{print $2}')

	[ "$current_volume_virtual_speaker" != "1.0" ] && wpctl set-volume $VIRTUAL_SPEAKER_ID 1.0
	[ "$current_volume_obs_mic" != "1.0" ] && wpctl set-volume $OBS_MIC_ID 1.0

	sleep 1
done
