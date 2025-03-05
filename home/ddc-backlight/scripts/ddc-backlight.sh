# Usage: ./ddc_backlight.sh <i2c-bus>
BUS="$1"
ICONS=("moon_empty" "moon_1" "moon_2" "moon_3" "moon_full")

# First check if DPMS is active using xset - safer than DDC commands
if xset q | grep -q "Monitor is in DPMS"; then
	# DPMS is active, don't try to communicate with the monitor
	echo "{\"icon\":\"${ICONS[0]}\",\"text\":\"0\",\"short_text\":\"\"}"
	exit 0
fi

# Check if X11 DPMS is enabled and if the monitor is in standby/suspend/off mode
dpms_state=$(xset q | grep "DPMS is" | awk '{print $3}')
if [ "$dpms_state" = "Enabled" ]; then
	monitor_state=$(xset q | grep -A1 "DPMS" | tail -n1)
	if echo "$monitor_state" | grep -q "Standby\|Suspend\|Off"; then
		# Monitor is in power saving mode, don't try DDC
		echo "{\"icon\":\"${ICONS[0]}\",\"text\":\"0\",\"short_text\":\"\"}"
		exit 0
	fi
fi

# Check if monitor is connected and turned on - with better error handling
# 1. Attempt to read the power state of the monitor using VCP code 0xD6 (Power Mode)
{
	power_output=$(timeout 2 ddcutil getvcp D6 -b "$BUS" --noverify --sleep-multiplier 2.0 2>&1)
	power_status=$?
} || {
	# If the timeout command itself fails, handle it gracefully
	power_status=1
}

if [ $power_status -ne 0 ]; then
	# Failed to read power state -> no monitor or unresponsive
	echo "{\"icon\":\"${ICONS[0]}\",\"text\":\"0\",\"short_text\":\"\"}"
	exit 0
fi

# 2. If it's not reported as On, treat it as off.
if ! echo "$power_output" | grep -q "DPM: On"; then
	echo "{\"icon\":\"${ICONS[0]}\",\"text\":\"0\",\"short_text\":\"\"}"
	exit 0
fi

# 3. Otherwise, we can safely get brightness value without overloading the kernel...
{
	output=$(timeout 2 ddcutil getvcp 10 -b "$BUS" --noverify --sleep-multiplier 2.0 2>&1)
	status=$?
} || {
	# If the timeout command itself fails, handle it gracefully
	status=1
}

if [ $status -ne 0 ]; then
	echo "{\"icon\":\"${ICONS[0]}\",\"text\":\"err\",\"short_text\":\"\",\"state\":\"critical\"}"
	exit 0
fi

# Extract percentage
percent=$(echo "$output" | awk -F'=' '/current value/ {gsub(/,.*$/, "", $2); print $2+0}')

# Calculate icon index
index=$((percent / 20))
[ $index -gt 4 ] && index=4

echo "{\"icon\":\"${ICONS[$index]}\",\"text\":\"${percent}\",\"short_text\":\"\"}"
