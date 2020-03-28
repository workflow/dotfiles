{ pkgs, ... }:

let

  packages = pkgs.callPackage ./packages {};

in

{
  imports = [
    ./nix

    ./system
    ./system/desktop
    ./system/keyboard
    ./system/power
    ./system/fonts
  ];

  environment.systemPackages = packages;
}
