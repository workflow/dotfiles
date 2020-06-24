{ pkgs, ... }:

let

  packages = pkgs.callPackage ./packages {};

in

{
  imports = [
    ./nix
    ./nix/home-manager.nix

    ./system
    ./system/desktop.nix
    ./system/fonts.nix
    ./system/keyboard.nix
    ./system/power.nix
  ];

  #environment.systemPackages = packages;
}
