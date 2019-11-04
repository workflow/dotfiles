{ pkgs }:

pkgs.myLib.shellScript "kbconfig" ''
  #!${pkgs.bash}/bin/bash

  setxkbmap -option
  setxkbmap -option ctrl:ralt_rctrl
  setxkbmap -layout us,gr -option grp:alt_space_toggle

  if [ "$1" == "both" ]; then
    xset r rate 500 45
    setxkbmap -option ctrl:nocaps
    ${pkgs.xcape}/bin/xcape -t "$${2:-300}" -e 'Control_L=Escape'
  else
    ${pkgs.killall}/bin/killall xcape || true
    xset r rate 500 45
    setxkbmap -option caps:escape
  fi
''
