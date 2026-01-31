{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.galaxy-buds-client = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [".local/share/GalaxyBudsClient"];
    };

    home.packages = [pkgs.galaxy-buds-client];
  };
}
