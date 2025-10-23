{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/libreoffice"
    ];
  };

  home.packages = [
    pkgs.libreoffice
  ];
}
