# Usage: ./ddc_backlight.sh <i2c-bus>
BUS="$1"
ICONS=("moon_empty" "moon_1" "moon_2" "moon_3" "moon_full")

# Check if monitor is connected and turned on
# 1. Attempt to read the power state of the monitor using VCP code 0xD6 (Power Mode).
#    If this fails, we assume there's no connected monitor on this bus, or it won't respond to DDC.
power_output=$(timeout 2 ddcutil getvcp D6 -b "$BUS" --noverify --sleep-multiplier 2.0 2>&1)
power_status=$?
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
output=$(timeout 2 ddcutil getvcp 10 -b "$BUS" --noverify --sleep-multiplier 2.0 2>&1)
status=$?

if [ $status -ne 0 ]; then
	echo "{\"full_text\":\"DDC Error\",\"color\":\"#ff0000\"}"
	exit 0
fi

# Extract percentage
percent=$(echo "$output" | awk -F'=' '/current value/ {gsub(/,.*$/, "", $2); print $2+0}')

# Calculate icon index
index=$((percent / 20))
[ $index -gt 4 ] && index=4

echo "{\"icon\":\"${ICONS[$index]}\",\"text\":\"${percent}\",\"short_text\":\"\"}"
