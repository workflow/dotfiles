{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.qalculate = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/qalculate"
        ".local/share/qalculate"
      ];
    };

    home.packages = [
      pkgs.qalculate-gtk
    ];
  };
}
