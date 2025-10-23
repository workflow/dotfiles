{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".local/share/GalaxyBudsClient"
    ];
  };

  home.packages = [
    pkgs.galaxy-buds-client
  ];
}
