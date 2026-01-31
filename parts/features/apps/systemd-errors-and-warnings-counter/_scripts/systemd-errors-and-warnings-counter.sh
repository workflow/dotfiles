WARNINGS=$(journalctl -p 4..4 --since "10 minutes ago" --boot --output json | wc -l)
ERRORS=$(journalctl -p 3..3 --since "10 minutes ago" --boot --output json | wc -l)

WARNING_ICON="⚠️"
ERROR_ICON="❗"

# Determine state based on number of errors
if [ "$ERRORS" -eq 0 ]; then
	STATE="Good"
elif [ "$ERRORS" -le 2 ]; then
	STATE="Info"
elif [ "$ERRORS" -le 5 ]; then
	STATE="Warning"
else
	STATE="Critical"
fi

echo "{\"text\":\"${ERROR_ICON}${ERRORS} ${WARNING_ICON}${WARNINGS}\",\"short_text\":\"${ERRORS}\",\"state\":\"${STATE}\"}"
