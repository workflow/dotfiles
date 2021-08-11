{ pkgs, ... }:
let

  packages = pkgs.callPackage ./packages { };

in
{
  imports = [
    ./nix
    ./nix/home-manager.nix

    ./system
    ./system/audio.nix
    ./system/gpu.nix
    ./system/desktop.nix
    ./system/fonts.nix
    ./system/keyboard.nix
    ./system/ledgerlive.nix
    ./system/networking.nix
    ./system/power.nix
    ./system/security.nix
    ./system/virtualisation.nix
  ];

  environment.systemPackages = packages;
}
