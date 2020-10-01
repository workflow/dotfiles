{ pkgs, ... }:
let

  packages = pkgs.callPackage ./packages { };

in
{
  imports = [
    ./nix
    ./nix/home-manager.nix

    ./system
    ./system/gpu.nix
    ./system/desktop.nix
    ./system/fonts.nix
    ./system/keyboard.nix
    ./system/power.nix
    ./system/virtualisation.nix
    ./system/ledgerlive.nix
  ];

  environment.systemPackages = packages;
}
