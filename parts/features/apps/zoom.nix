{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.zoom = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      files = [
        ".config/zoom.conf"
        ".config/zoomus.conf"
      ];
      directories = [
        ".zoom"
        ".cache/zoom"
      ];
    };

    home.packages = [
      pkgs.zoom-us
    ];
  };
}
