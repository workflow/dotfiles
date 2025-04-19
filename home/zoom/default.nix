{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
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
