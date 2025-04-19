{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/libreoffice"
    ];
  };

  home.packages = [
    pkgs.libreoffice
  ];
}
