{ pkgs ? import <nixpkgs> { }, localLib ? import ../../lib { pkgs = pkgs; } }:

let

  src = builtins.fetchurl "https://get.haskellstack.org/";

in localLib.shellScript "install-stack" ''
  sh ${src} -d $HOME/.local/bin
''
