# Toggles wlsunset (gamma) and wluma (brightness) together.
# Originally looted from https://github.com/CyrilSLi/linux-scripts
# Coordinates come from the active IANA timezone (kept current by tzupdate),
# resolved offline via the tzdata table -- no geolocation API, no network.
ZONE_TAB=/etc/zoneinfo/zone1970.tab

main() {
	if pgrep -x wlsunset; then
		stop_nightlight
	else
		start_nightlight
	fi
	pkill -35 waybar
}

stop_nightlight() {
	killall -9 wlsunset
	systemctl --user stop wluma.service
}

start_nightlight() {
	local coords
	if ! coords=$(timezone_coords); then
		notify-send wlsunset.sh "No coordinates for timezone $(current_timezone); skipping."
		return
	fi
	read -r latitude longitude <<<"$coords"
	wlsunset -l "$latitude" -L "$longitude" &
	systemctl --user start wluma.service
}

# Representative "LAT LON" (decimal degrees) for the active timezone, or exit 1.
timezone_coords() {
	local iso
	iso=$(awk -v tz="$(current_timezone)" '$3 == tz {print $2; exit}' "$ZONE_TAB")
	[ -n "$iso" ] || return 1
	iso6709_to_decimal "$iso"
}

current_timezone() {
	timedatectl show -p Timezone --value
}

# ISO 6709 "±DDMM[SS]±DDDMM[SS]" (as stored in zone1970.tab) -> "LAT LON".
iso6709_to_decimal() {
	local iso=$1
	[[ $iso =~ ^([+-])([0-9]{2})([0-9]{2})([0-9]{2})?([+-])([0-9]{3})([0-9]{2})([0-9]{2})?$ ]] || return 1
	local lat lon
	lat=$(dms_to_decimal "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}" "${BASH_REMATCH[4]}")
	lon=$(dms_to_decimal "${BASH_REMATCH[5]}" "${BASH_REMATCH[6]}" "${BASH_REMATCH[7]}" "${BASH_REMATCH[8]}")
	echo "$lat $lon"
}

dms_to_decimal() {
	local sign=$1 degrees=$2 minutes=$3 seconds=${4:-0}
	awk -v s="$sign" -v d="$degrees" -v m="$minutes" -v sec="$seconds" \
		'BEGIN { v = d + m / 60 + sec / 3600; printf "%.4f", (s == "-" ? -v : v) }'
}

main
