{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.libreoffice = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/libreoffice"
      ];
    };

    home.packages = [
      pkgs.libreoffice
    ];
  };
}
