{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".local/share/GalaxyBudsClient"
    ];
  };

  home.packages = [
    pkgs.galaxy-buds-client
  ];
}
