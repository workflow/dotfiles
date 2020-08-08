#! /run/current-system/sw/bin/bash
set -euo pipefail

sleep 20
i3-msg 'workspace number1; exec kcmshell5 kcm_networkmanagement'
sleep 1
i3-msg 'exec ssh-add -q < /dev/null'
