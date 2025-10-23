{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".PortfolioPerformance"
    ];
  };

  home.packages = [
    pkgs.unstable.portfolio
  ];
}
