{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/solaar"
    ];
  };

  home.packages = [
    pkgs.hicolor-icon-theme
    pkgs.solaar
  ];
}
