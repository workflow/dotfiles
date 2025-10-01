# Simple calculator wrapper for fuzzel --dmenu using qalc.
# - Prompts for an expression via fuzzel
# - Evaluates it with qalc
# - Copies the result to the clipboard
# - Shows a notification with the result

prompt="calc> "

# Prefer dunstify if available; otherwise fall back to notify-send.
NOTIFY_BIN="$(command -v dunstify || true)"
if [ -z "$NOTIFY_BIN" ]; then
  NOTIFY_BIN="$(command -v notify-send || true)"
fi
ICON_NAME="accessories-calculator"

notify() {
  # Usage: notify "summary" "body"
  local summary="$1"
  local body="$2"
  if [ -n "$NOTIFY_BIN" ]; then
    # Set an app name for nicer presentation; both dunstify and notify-send support -a
    "$NOTIFY_BIN" -a "Calc" -i "$ICON_NAME" "$summary" "$body" || true
  fi
}

# Ask the user for an expression using fuzzel's dmenu mode.
# We feed an empty list so that free-form input is returned.
expr_input="$(printf '%s' "" | fuzzel --dmenu --prompt "$prompt" --lines 0 2>/dev/null || true)"

# Exit silently if the user cancelled or input is empty/whitespace.
if [ -z "${expr_input//[[:space:]]/}" ]; then
  exit 0
fi

# Evaluate the expression using qalc in terse mode to get only the result.
# If qalc fails, we notify and exit with non-zero status.
result="$(qalc -t -- "$expr_input" 2>/dev/null || true)"
# Normalize whitespace/newlines
result="$(printf '%s' "$result" | tr '\n' ' ' | sed 's/^\s\+//; s/\s\+$//')"

if [ -z "$result" ]; then
  notify "Calc" "Invalid expression: $expr_input"
  exit 1
fi

# Copy to clipboard
printf '%s' "$result" | wl-copy

# Notify the user
notify "Calc" "$expr_input = $result (copied to clipboard)"

# Print to stdout as well (useful for logs)
printf '%s\n' "$result"
