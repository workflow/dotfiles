{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.mpv = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/mpv"
        ".cache/mpv"
      ];
    };

    home.packages = [
      pkgs.mpv
    ];
  };
}
