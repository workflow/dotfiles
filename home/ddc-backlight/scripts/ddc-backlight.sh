# Usage: ./ddc_backlight.sh <i2c-bus>
BUS="$1"
ICONS=("moon_empty" "moon_1" "moon_2" "moon_3" "moon_full")

# Check if monitor is connected and turned on - with better error handling
# 1. Attempt to read the power state of the monitor using VCP code 0xD6 (Power Mode)
{
	timeout 2 ddcutil getvcp D6 -b "$BUS" --noverify --sleep-multiplier 2.0 >/dev/null
	power_status=$?
} || {
	power_status=1
}

if [ $power_status -ne 0 ]; then
	# Failed to read power state -> no monitor or unresponsive
	echo "{\"icon\":\"${ICONS[0]}\",\"text\":\"0\",\"short_text\":\"\"}"
	exit 0
fi

# Otherwise, we can safely get brightness value without overloading the kernel...
{
	output=$(timeout 2 ddcutil getvcp 10 -b "$BUS" --noverify --sleep-multiplier 2.0 2>&1)
	status=$?
} || {
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
