#!/usr/bin/env bash

set -euo pipefail

xidlehook-client --socket /tmp/xidlehook.sock control --action disable --timer 0 --timer 1
xidlehook-client --socket /tmp/xidlehook.sock query
