{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.calibre = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        "Calibre Library"
        ".config/calibre"
        ".cache/calibre"
      ];
    };

    home.packages = [pkgs.calibre];
  };
}
