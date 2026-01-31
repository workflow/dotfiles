set -euo pipefail

isOnline=$(tailscale status --json | jq -r '.Self.Online')
if [[ "$isOnline" == "true" ]]; then
  tailscaleIp=$(tailscale status --json | jq -r '.Self.TailscaleIPs[0]')
  echo "{\"icon\": \"tailscale_up\", \"text\": \"$tailscaleIp\", \"state\": \"Good\"}"
else
  echo "{\"icon\": \"tailscale_down\", \"text\": \"\", \"state\": \"Idle\"}"
fi
