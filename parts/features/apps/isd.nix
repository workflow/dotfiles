{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.isd = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/isd_tui"
        ".local/share/isd_tui"
        ".cache/isd_tui"
      ];
    };

    home.packages = [pkgs.isd];
  };
}
