dunstctl set-paused toggle

if dunstctl is-paused | grep -q "true"; then
	if command -v peon >/dev/null 2>&1; then
		peon pause
		peon notifications off
	fi
else
	if command -v peon >/dev/null 2>&1; then
		peon resume
		peon notifications on
	fi
fi
