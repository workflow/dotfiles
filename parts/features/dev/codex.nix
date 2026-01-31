{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.codex = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [".codex"];
    };

    home.packages = [pkgs.unstable.codex];
  };
}
