#! /run/current-system/sw/bin/bash
set -euo pipefail

hostname="$(hostname)"

case "$hostname" in
"boar")
	autorandr boar
	;;
"flexbox")
	autorandr flexbox || true
	autorandr flexbox-intel || true
	autorandr flexbox-intel-lo-res || true
	autorandr flexbox-caparica || true
	;;
*)
	echo "unknown - skipping autorandr setup"
	;;
esac
