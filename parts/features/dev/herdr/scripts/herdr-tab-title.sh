# Sync the herdr tab label with an agent's session name. Without an argument
# the name is taken from the pane's terminal title (claude sets it there;
# registered for SessionStart and Stop so the label follows renames without
# polling). The opencode plugin passes the session title explicitly instead.

[ "${HERDR_ENV:-}" = "1" ] || exit 0
[ -n "${HERDR_PANE_ID:-}" ] || exit 0

pane_json=$(herdr pane get "$HERDR_PANE_ID") || exit 0
title=${1:-$(printf '%s' "$pane_json" | jq -r '.result.pane.terminal_title_stripped // empty')}
tab_id=$(printf '%s' "$pane_json" | jq -r '.result.pane.tab_id // empty')

[ -n "$title" ] && [ -n "$tab_id" ] || exit 0
herdr tab rename "$tab_id" "$title" >/dev/null 2>&1 || true
