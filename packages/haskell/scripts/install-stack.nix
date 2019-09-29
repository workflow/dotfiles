{ pkgs ? import <nixpkgs> { }, myLib ? import ../../lib { pkgs = pkgs; } }:

let

  src = builtins.fetchurl "https://get.haskellstack.org/";

in myLib.shellScript "install-stack" ''
  sh ${src} -d $HOME/.local/bin
''
