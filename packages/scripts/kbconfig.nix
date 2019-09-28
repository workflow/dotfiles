{ pkgs ? import <nixpkgs> { }, localLib ? import ../../lib { pkgs = pkgs; } }:

localLib.shellScript "kbconfig" ''
  #!${pkgs.bash}/bin/bash

  xset r rate 500 45
  setxkbmap -option caps:escape
  setxkbmap -option ctrl:ralt_rctrl
  setxkbmap -layout us,gr -option grp:alt_space_toggle
''
