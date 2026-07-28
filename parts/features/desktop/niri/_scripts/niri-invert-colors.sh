# Toggles whole-screen color inversion via wlr-gamma-control (wl-gammactl).
# Only one client may hold gamma control per output, so nightlight (wlsunset)
# is paused while inverted and restored when toggling back.
# nightlight-toggle comes from the waybar feature via the session PATH.

state_file="${XDG_RUNTIME_DIR:-/tmp}/niri-invert-colors.nightlight-paused"

if pgrep -x wl-gammactl >/dev/null; then
	pkill -x wl-gammactl # gamma restores when the client's connection closes
	if [[ -e $state_file ]]; then
		rm -f "$state_file"
		nightlight-toggle >/dev/null 2>&1 &
	fi
else
	if pgrep -x wlsunset >/dev/null; then
		touch "$state_file"
		nightlight-toggle >/dev/null 2>&1
		sleep 0.5 # let niri release wlsunset's gamma control
	fi
	setsid -f wl-gammactl -c -1 -b 2 -g 1
fi
