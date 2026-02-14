for line in $(niri msg --json windows | jq -r '.[] | select(.app_id == "Alacritty") | "\(.id):\(.pid)"'); do
	wid=${line%%:*}
	wpid=${line##*:}
	if pstree -p "$wpid" 2>/dev/null | grep -q "claude"; then
		niri msg action focus-window --id "$wid"
		break
	fi
done
