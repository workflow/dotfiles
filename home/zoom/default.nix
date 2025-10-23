{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    files = [
      ".config/zoom.conf"
      ".config/zoomus.conf"
    ];
    directories = [
      ".zoom"
      ".cache/zoom"
    ];
  };

  home.packages = [
    pkgs.zoom-us
  ];
}
