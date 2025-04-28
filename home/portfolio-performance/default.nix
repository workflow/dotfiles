{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".PortfolioPerformance"
    ];
  };

  home.packages = [
    pkgs.portfolio
  ];
}
