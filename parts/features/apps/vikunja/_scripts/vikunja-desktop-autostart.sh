# Wait for the Vikunja server before launching the desktop app. The app is
# only reachable over the tailnet, and launching it before Tailscale is up
# makes its OAuth token refresh fail, which drops the session and forces a
# re-login on every boot.

for _ in $(seq 60); do
  if curl --silent --fail --max-time 5 --output /dev/null "$VIKUNJA_URL/api/v1/info"; then
    break
  fi
  sleep 2
done

exec vikunja-desktop "$@"
