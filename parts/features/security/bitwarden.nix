{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.bitwarden = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/Bitwarden"
      ];
    };

    home.packages = [
      pkgs.bitwarden-desktop
      pkgs.bitwarden-cli
    ];
  };
}
