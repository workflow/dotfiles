set -euo pipefail

current_mode=$(cpupower frequency-info | grep -oP '(?<= governor ").*(?=")')

if [[ "${1:-}" == "--toggle" ]]; then
	if [ "$current_mode" == "powersave" ]; then
		sudo auto-cpufreq --force performance >/dev/null 2>&1
		echo "{\"icon\": \"performance\", \"text\": \"\", \"state\": \"Good\"}"
	elif [ "$current_mode" == "performance" ]; then
		sudo auto-cpufreq --force powersave >/dev/null 2>&1
		echo "{\"icon\": \"powersave\", \"text\": \"\", \"state\": \"Good\"}"
	fi
else
	if [ "$current_mode" == "powersave" ]; then
		echo "{\"icon\": \"powersave\", \"text\": \"\", \"state\": \"Good\"}"
	elif [ "$current_mode" == "performance" ]; then
		echo "{\"icon\": \"performance\", \"text\": \"\", \"state\": \"Good\"}"
	fi
fi
