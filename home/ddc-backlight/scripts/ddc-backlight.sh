# Usage: ./ddc_backlight.sh <i2c-bus>
BUS="$1"
ICONS=("moon_empty" "moon_1" "moon_2" "moon_3" "moon_full")

LOCK_FILE="/tmp/ddc_backlight.lock"

# Deterministic delay based on bus number to stagger execution
# Each bus will delay a different amount (0-59 seconds)
DELAY=$((BUS * 7 % 60))
sleep "$DELAY"

# Prevent parallel execution, which can crash the kernel 
if ! flock --nonblock 9; then
	# Return a temporary placeholder instead of waiting
	echo "{\"icon\":\"${ICONS[0]}\",\"text\":\"...\",\"short_text\":\"\"}"
	exit 0
fi 9>"$LOCK_FILE"

# Check if monitor is connected and turned on - with better error handling
# 1. Attempt to read the power state of the monitor using VCP code 0xD6 (Power Mode)
{
	timeout 2 ddcutil getvcp D6 -b "$BUS" >/dev/null
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
	output=$(timeout 2 ddcutil getvcp 10 -b "$BUS" 2>&1)
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
