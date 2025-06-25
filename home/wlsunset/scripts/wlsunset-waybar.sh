# Originally looted from https://github.com/CyrilSLi/linux-scripts
if pgrep -x wlsunset; then
	killall -9 wlsunset
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
	wlsunset -l "$latitude" -L "$longitude" &
fi
pkill -35 waybar
