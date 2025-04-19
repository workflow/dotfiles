{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/solaar"
    ];
  };

  home.packages = [
    pkgs.hicolor-icon-theme
    pkgs.solaar
  ];
}
