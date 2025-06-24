# Usage: ./ddc_backlight.sh <i2c-bus>
BUS="$1"

LOCK_FILE="/tmp/ddc_backlight.lock"

# Deterministic delay based on bus number to stagger execution
# Each bus will delay a different amount (0-59 seconds)
DELAY=$((BUS * 7 % 60))
sleep "$DELAY"

# Prevent parallel execution, which can crash the kernel 
if ! flock --nonblock 9; then
	# Return a temporary placeholder instead of waiting
	echo "{\"percentage\":0}"
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
	echo "{\"percentage\":0}"
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
	echo "{\"percentage\":0}"
	exit 0
fi

# Extract percentage
percent=$(echo "$output" | awk -F'=' '/current value/ {gsub(/,.*$/, "", $2); print $2+0}')

echo "{\"percentage\":${percent}}"
