# Take a fullscreen screenshot of the focused screen via niri and open it with Satty

temp_file=$(mktemp --suffix=".png")

cleanup() {
  rm -f "$temp_file"
}
trap cleanup EXIT

if ! niri msg action screenshot-screen --show-pointer false --path "$temp_file"; then
  echo "Failed to take screenshot" >&2
  exit 1
fi

wait_for_screenshot() {
  # niri writes the file asynchronously after the action returns
  for _ in $(seq 1 40); do
    if [ -s "$temp_file" ]; then
      sleep 0.05
      return 0
    fi
    sleep 0.05
  done
  return 1
}

if ! wait_for_screenshot; then
  echo "Screenshot was not written to $temp_file" >&2
  exit 1
fi

satty --filename "$temp_file" --copy-command "wl-copy" --early-exit
