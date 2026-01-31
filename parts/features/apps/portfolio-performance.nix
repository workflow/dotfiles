{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.portfolio-performance = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [".PortfolioPerformance"];
    };

    home.packages = [pkgs.unstable.portfolio];
  };
}
