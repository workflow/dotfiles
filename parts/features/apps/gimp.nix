{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.gimp = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/GIMP"
        ".cache/gimp"
      ];
    };

    home.packages = [
      pkgs.gimp
    ];
  };
}
