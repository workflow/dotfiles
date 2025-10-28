# Take a fullscreen screenshot of the current focused screen and open it with Satty

temp_file=$(mktemp --suffix=".png")

# Try to get the focused output, fallback to just taking a screenshot of all outputs
focused_output=$(niri msg --json focused-output 2>/dev/null | jq -r '.name' 2>/dev/null || echo "")

# Take the screenshot
screenshot_success=false
if [ -n "$focused_output" ]; then
    if grim -o "$focused_output" "$temp_file"; then
        screenshot_success=true
    fi
else
    if grim "$temp_file"; then
        screenshot_success=true
    fi
fi

if [ "$screenshot_success" = true ]; then
    # Open the screenshot with Satty for editing
    satty --filename "$temp_file" --copy-command "wl-copy" --early-exit

    # Clean up the temporary file
    rm "$temp_file"
else
    echo "Failed to take screenshot" >&2
    rm "$temp_file"
    exit 1
fi
