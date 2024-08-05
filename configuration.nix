{
  pkgs,
  lib,
  secrets,
  inputs,
  ...
}: let
  packages = pkgs.callPackage ./packages {inherit inputs;};
in {
  imports =
    [
      ./nix

      ./system
      ./system/audio.nix
      ./system/desktop.nix
      ./system/dns.nix
      ./system/fonts.nix
      ./system/gpu.nix
      ./system/io
      ./system/ledgerlive.nix
      ./system/networking.nix
      ./system/nix-ld.nix
      ./system/performance.nix
      ./system/power.nix
      ./system/printing.nix
      ./system/screens.nix
      ./system/security.nix
      ./system/steam.nix
      ./system/video
      ./system/virtualisation.nix
    ]
    ++ lib.lists.optionals (secrets ? systemSecrets) secrets.systemSecrets;

  environment.systemPackages = packages;
}
