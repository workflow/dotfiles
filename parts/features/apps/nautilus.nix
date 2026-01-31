{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.nautilus = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/nautilus"
        ".local/share/nautilus"
      ];
    };

    home.packages = [pkgs.nautilus];
  };
}
