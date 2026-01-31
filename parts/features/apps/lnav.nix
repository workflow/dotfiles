{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.lnav = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [".config/lnav"];
    };

    home.packages = [pkgs.lnav];
  };
}
