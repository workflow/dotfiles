{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      "Calibre Library"
      ".config/calibre"
      ".cache/calibre"
    ];
  };

  home.packages = [
    pkgs.calibre
  ];
}
