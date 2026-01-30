# Grab the current windows from Niri (id, title, app_id, workspace_id, …)
wins_json="$(niri msg --json windows)"

# Keep a parallel list of window IDs so we can map fuzzel's index → id.
mapfile -t IDS < <(jq -r '.[].id' <<<"$wins_json")

# Resolve an icon name from .desktop files for a given app_id.
resolve_icon_from_desktop() {
  # We try exact app_id.desktop and its last reverse-DNS segment.
  # We return the Icon= value if found (prefer theme name without extension unless absolute path).
  local appid="$1"
  [ -z "$appid" ] && return 1
  local xdg_home="${XDG_DATA_HOME:-$HOME/.local/share}"
  local xdg_dirs="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
  local -a search_dirs=("$xdg_home/applications")
  IFS=: read -r -a _xdg_dirs <<<"$xdg_dirs"
  for d in "${_xdg_dirs[@]}"; do
    search_dirs+=("$d/applications")
  done
  local last_seg="${appid##*.}"
  local name
  for name in "$appid" "$last_seg"; do
    for d in "${search_dirs[@]}"; do
      if [ -f "$d/$name.desktop" ]; then
        # Extract first Icon= value
        local icon
        icon="$(sed -n 's/^Icon=\(.*\)$/\1/p' "$d/$name.desktop" | head -n 1)"
        if [ -n "$icon" ]; then
          case "$icon" in
            /*) printf '%s' "$icon" ;;
            *.png|*.svg|*.xpm) printf '%s' "${icon%.*}" ;;
            *) printf '%s' "$icon" ;;
          esac
          return 0
        fi
      fi
    done
  done
  return 1
}

# Build the fuzzel menu. We attach icons using the Rofi extended dmenu protocol:
# append a NUL, then "icon", then unit-separator, then the comma-separated icon names.
SEL_IDX="$(
	# Create TAB-separated lines: label \t icon-candidates \t app_id
	jq -r '
    def slug: (. // "") | ascii_downcase | gsub("[^a-z0-9]+"; "-");
    def hyphenate: (. // "") | ascii_downcase | gsub("[.]+"; "-");

    .[] as $w
    | ($w.app_id // "") as $app_raw
    | ($app_raw | ascii_downcase) as $app
    | ($app | split(".")) as $parts
    | ($parts | length) as $len
    | (if $len > 0 then $parts[$len-1] else "" end) as $last
    | (if $len > 1 then $parts[$len-2] else "" end) as $penult
    | ($app | hyphenate) as $app_hyph
    | ($last | slug) as $last_slug
    | ($penult | slug) as $penult_slug
    | [
        $app,
        $app_hyph,
        (if $len > 1 then ($penult_slug + "-" + $last_slug) else null end),
        $penult,
        $last,
        $penult_slug,
        $last_slug,
        "application-default-icon",
        "application-x-executable"
      ]
      | map(select(. != null and . != ""))
      | join(",") as $icons
    | "\($w.title) — [ws \($w.workspace_id)] (\($w.app_id // "?"))\t\($icons)\t\($app_raw)"
  ' <<<"$wins_json" |
  # For each line, optionally prefix the candidate list with the .desktop Icon= value,
  # then convert to the dmenu icon protocol with real NUL (0) and US (31) separators.
  while IFS=$'\t' read -r label icons appid; do
    resolved_icon="$(resolve_icon_from_desktop "$appid" 2>/dev/null || true)"
    if [ -n "$resolved_icon" ]; then
      icons="$resolved_icon,$icons"
    fi
    printf '%s\t%s\n' "$label" "$icons"
  done |
  awk -v FS='\t' 'BEGIN{ nul=sprintf("%c",0); us=sprintf("%c",31);} { printf "%s" nul "icon" us "%s\n", $1, $2 }' |
		fuzzel --dmenu --index --icon-theme Papirus-Dark --log-level info 2>"${XDG_CACHE_HOME:-$HOME/.cache}"/niri-pick-window-fuzzel.log
)"

# If the user cancelled, exit quietly.
[[ -z "${SEL_IDX}" ]] && exit 0

# Focus the selected window by ID.
niri msg action focus-window --id "${IDS[$SEL_IDX]}"
