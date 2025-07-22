windows=$(niri msg --json windows)

idx=$(printf '%s\n' "$windows" |
	jq -r 'map(.title // .app_id) | .[]' |
	fuzzel --dmenu --index)

id=$(printf '%s\n' "$windows" |
	jq -r ".[$idx].id")

niri msg action focus-window --id "$id"
