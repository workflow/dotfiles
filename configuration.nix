{ pkgs, lib, ... }:
let

  packages = pkgs.callPackage ./packages { };

  nixos-secrets-path = /home/farlion/nixos-secrets;

in
{
  imports = [
    ./nix
    ./nix/home-manager.nix

    ./system
    ./system/audio.nix
    ./system/desktop.nix
    ./system/fonts.nix
    ./system/ledgerlive.nix
    ./system/networking.nix
    ./system/nix-ld.nix
    ./system/power.nix
    ./system/security.nix
    ./system/virtualisation.nix
  ] ++ lib.lists.optional (lib.pathExists nixos-secrets-path) nixos-secrets-path;

  environment.systemPackages = packages;
}
