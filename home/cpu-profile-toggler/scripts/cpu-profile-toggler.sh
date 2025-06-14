current_mode=$(cpupower frequency-info | grep -oP '(?<= governor ").*(?=")')

if [[ "${1:-}" == "--toggle" ]]; then
	if [ "$current_mode" == "powersave" ]; then
		sudo auto-cpufreq --force performance
	elif [ "$current_mode" == "performance" ]; then
		sudo auto-cpufreq --force powersave
	fi
elif [[ "${1:-}" == "--reset" ]]; then
	if [ "$current_mode" == "powersave" ]; then
		sudo auto-cpufreq --force reset
	fi
else
	if [ "$current_mode" == "powersave" ]; then
		echo "{\"alt\": \"powersave\"}"
	elif [ "$current_mode" == "performance" ]; then
		echo "{\"alt\": \"performance\"}"
	fi
fi
