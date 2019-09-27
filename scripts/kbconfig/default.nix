{ pkgs ? import <nixpkgs> {} }:

# testing setting these with nix for now
# setxkbmap -option caps:escape
# setxkbmap -option ctrl:ralt_rctrl
# setxkbmap -layout us,gr -option grp:alt_space_toggle

pkgs.writeScriptBin "kbconfig" ''
  #!${pkgs.bash}/bin/bash

  xset r rate 500 45
''

