# Take a fullscreen screenshot of the current focused screen and open it with Satty

temp_file=$(mktemp --suffix=".png")

# Try to get the focused output, fallback to just taking a screenshot of all outputs
focused_output=$(niri msg outputs 2>/dev/null | jq -r '.[] | select(.focused == true) | .name' 2>/dev/null || echo "")
if [ -n "$focused_output" ]; then
    screenshot_cmd="grim -o \"$focused_output\" \"$temp_file\""
else
    screenshot_cmd="grim \"$temp_file\""
fi

if eval "$screenshot_cmd"; then
    # Open the screenshot with Satty for editing
    satty --filename "$temp_file" --copy-command "wl-copy" --early-exit

    # Clean up the temporary file
    rm "$temp_file"
else
    echo "Failed to take screenshot" >&2
    rm "$temp_file"
    exit 1
fi
