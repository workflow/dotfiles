{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.aws = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [".aws"];
    };

    home.packages = [pkgs.awscli2];
  };
}
