# Looted from https://github.com/CyrilSLi/linux-scripts
if pgrep wlsunset >/dev/null 2>&1; then
	killall -9 wlsunset >/dev/null 2>&1
else
	RETRIES=30
	counter=0
	while true; do
		if CONTENT=$(curl -s http://ip-api.com/json/); then
			break
		fi
		counter=$((counter + 1))
		if [ $counter -eq $RETRIES ]; then
			notify-send wlsunset.sh "Unable to connect to ip-api."
			break
		fi
		sleep 2
	done
	longitude=$(echo "$CONTENT" | jq .lon)
	latitude=$(echo "$CONTENT" | jq .lat)
	wlsunset -l "$latitude" -L "$longitude" >/dev/null 2>&1 &
fi
pkill -35 waybar
