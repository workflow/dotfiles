{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.devenv = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".local/share/devenv"
      ];
    };

    home.packages = [
      pkgs.devenv
    ];
  };
}
