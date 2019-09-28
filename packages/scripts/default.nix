{ pkgs, ... }:

let

  kbconfig = pkgs.callPackage ./kbconfig.nix {};

in

{
  environment.systemPackages = [
    kbconfig
  ];
}
