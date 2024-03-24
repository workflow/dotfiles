#! /run/current-system/sw/bin/bash
set -euo pipefail

# See https://discourse.nixos.org/t/brightness-control-of-external-monitors-with-ddcci-backlight/8639/10

sleep 5

echo Trying to attach ddcci to i2c-4
counter=10
while [ $counter -gt 0 ]; do
	if ddcutil getvcp 10 -b 4; then
		echo ddcci 0x37 >/sys/bus/i2c/devices/i2c-4/new_device
		break
	fi
	sleep 1
	counter=$((counter - 1))
done

echo Trying to attach ddcci to i2c-5
counter=10
while [ $counter -gt 0 ]; do
	if ddcutil getvcp 10 -b 5; then
		echo ddcci 0x37 >/sys/bus/i2c/devices/i2c-5/new_device
		break
	fi
	sleep 1
	counter=$((counter - 1))
done
