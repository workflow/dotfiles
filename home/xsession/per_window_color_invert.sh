#! /run/current-system/sw/bin/bash
set -euo pipefail
xprop -id "$(xdotool getwindowfocus)" -format TAG_INVERT 8c \
	-set TAG_INVERT "$(
		xprop -id "$(xdotool getwindowfocus)" 8c TAG_INVERT |
			sed -e 's/.*= 1.*/0/' -e 's/.*= 0.*/1/' -e 's/.*not found.*/1/'
	)"
