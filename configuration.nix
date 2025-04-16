{
  inputs,
  isImpermanent,
  lib,
  pkgs,
  secrets,
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
      ./system/firmware
      ./system/fonts.nix
      ./system/io
      ./system/kind-killer
      ./system/ledgerlive.nix
      ./system/networking.nix
      ./system/nix-ld.nix
      ./system/performance.nix
      ./system/power.nix
      ./system/printing.nix
      ./system/security.nix
      ./system/steam.nix
      ./system/stylix
      ./system/video
      ./system/virtualisation.nix

      ./specialisations/light
    ]
    ++ lib.lists.optionals isImpermanent [./system/impermanence]
    ++ lib.lists.optionals (secrets ? systemSecrets) secrets.systemSecrets;

  environment.systemPackages = packages;
}
