{ pkgs, lib, secrets, inputs, ... }:
let

  packages = pkgs.callPackage ./packages { inherit inputs; };

in
{
  imports = [
    ./nix

    ./system
    ./system/audio.nix
    ./system/desktop.nix
    ./system/fonts.nix
    ./system/keyboard.nix
    ./system/ledgerlive.nix
    ./system/gpu.nix
    ./system/networking.nix
    ./system/nix-ld.nix
    ./system/performance.nix
    ./system/power.nix
    ./system/screens.nix
    ./system/security.nix
    ./system/steam.nix
    ./system/virtualisation.nix

  ]
  ++ lib.lists.optional (secrets ? systemSecrets) secrets.systemSecrets;

  environment.systemPackages = packages;
}
