#! /run/current-system/sw/bin/bash
set -euo pipefail

autorandr sophia || true
autorandr --change
