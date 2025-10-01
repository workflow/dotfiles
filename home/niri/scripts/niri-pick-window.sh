# Grab the current windows from Niri (id, title, app_id, workspace_id, …)
wins_json="$(niri msg --json windows)"

# Keep a parallel list of window IDs so we can map fuzzel's index → id.
mapfile -t IDS < <(jq -r '.[].id' <<<"$wins_json")

# Build the fuzzel menu. We attach icons using the Rofi extended dmenu protocol:
# append a NUL, then "icon", then unit-separator, then the icon name(s).
# We try the full app_id first, then a short version after the final dot,
# then generic fallbacks so something shows up even if the theme lacks an icon.
SEL_IDX="$(
	jq -r '
    .[] as $w
    | ($w.app_id // "application-x-executable") as $app
    | ($app | ascii_downcase | split(".") | last) as $short
    | "\($w.title) — [ws \($w.workspace_id)] (\($w.app_id // "?"))\u0000icon\u001f\($app),\($short),application-default-icon,application-x-executable"
  ' <<<"$wins_json" |
		fuzzel --dmenu --index
)"

# If the user cancelled, exit quietly.
[[ -z "${SEL_IDX}" ]] && exit 0

# Focus the selected window by ID.
niri msg action focus-window --id "${IDS[$SEL_IDX]}"
