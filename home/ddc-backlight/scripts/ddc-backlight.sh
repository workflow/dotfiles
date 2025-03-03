# Usage: ./ddc_backlight.sh <i2c-bus>
BUS="$1"
ICONS=("moon_empty" "moon_1" "moon_2" "moon_3" "moon_full")

# Get brightness value
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
