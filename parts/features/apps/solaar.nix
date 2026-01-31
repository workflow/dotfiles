{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.solaar = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [".config/solaar"];
    };

    home.packages = [
      pkgs.hicolor-icon-theme
      pkgs.solaar
    ];
  };
}
