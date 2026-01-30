if dunstctl is-paused | grep -q "true"; then
	state="dnd"
else
	state="running"
fi

count=$(dunstctl count waiting)

printf '{"alt":"%s","text":%d,"class":"%s"}\n' "$state" "$count" "$state"
