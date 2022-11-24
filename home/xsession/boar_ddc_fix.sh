#! /run/current-system/sw/bin/bash
set -euo pipefail

# See https://discourse.nixos.org/t/brightness-control-of-external-monitors-with-ddcci-backlight/8639/10
sleep 10
echo 'ddcci 0x37' | tee /sys/bus/i2c/devices/i2c-3/new_device
echo 'ddcci 0x37' | tee /sys/bus/i2c/devices/i2c-4/new_device
