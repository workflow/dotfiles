{ pkgs }:

let

  myLib = pkgs.callPackage ../../lib.nix { };

in

myLib.shellScript "kbconfig" ''
  #!${pkgs.bash}/bin/bash

  ${pkgs.killall}/bin/killall xcape || true
  setxkbmap -option
  setxkbmap -option ctrl:ralt_rctrl
  setxkbmap -layout us,gr -option grp:alt_space_toggle

  if [ "$1" == "both" ]; then
    xset r rate 500 45
    setxkbmap -option ctrl:nocaps
    ${pkgs.xcape}/bin/xcape -t 300 -e 'Control_L=Escape'
  elif [ "$1" == "keep" ]; then
    xset r rate 500 45
    setxkbmap -option ctrl:nocaps
    ${pkgs.xcape}/bin/xcape -d -t 300 -e 'Control_L=Escape'
  else
    xset r rate 500 45
    setxkbmap -option caps:escape
  fi
''
