#! /run/current-system/sw/bin/bash
set -euo pipefail

hostname="$(hostname)"

case "$hostname" in
"boar")
	autorandr boar
	;;
"flexbox")
	autorandr flexbox-intel-hidpi
	;;
*)
	echo "unknown - skipping autorandr setup"
	;;
esac
