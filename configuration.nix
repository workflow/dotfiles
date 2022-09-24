{ pkgs, lib, ... }:
let

  packages = pkgs.callPackage ./packages { };

  nixos-secrets-path = /home/farlion/nixos-secrets;

in
{
  imports = [
    # TODO: merge this under system/
    ./nix

    ./system
    ./system/audio.nix
    ./system/desktop.nix
    ./system/fonts.nix
    ./system/keyboard.nix
    ./system/ledgerlive.nix
    ./system/networking.nix
    ./system/nix-ld.nix
    ./system/power.nix
    ./system/security.nix
    ./system/steam.nix
    ./system/virtualisation.nix

    ./hardware-configuration.nix

  ]
  ++ lib.lists.optional (lib.pathExists nixos-secrets-path) nixos-secrets-path;

  environment.systemPackages = packages;
}
