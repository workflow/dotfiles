{...}: {
  flake.modules.homeManager.portfolio-performance = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".PortfolioPerformance"];
    };

    home.packages = [pkgs.unstable.portfolio];
  };
}
