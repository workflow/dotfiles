{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.zoom-us
  ];

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
}
