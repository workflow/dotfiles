{ pkgs, ... }:

let

  packages = pkgs.callPackage ./packages {};

in

{
  imports = [
    ./nix

    ./system
    ./system/desktop
    ./system/fonts.nix
    ./system/keyboard.nix
    ./system/power
  ];

  environment.systemPackages = packages;
}
