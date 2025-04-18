{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.calibre
  ];

  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      "Calibre Library"
      ".config/calibre"
      ".cache/calibre"
    ];
  };
}
