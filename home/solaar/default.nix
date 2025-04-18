{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.hicolor-icon-theme
    pkgs.solaar
  ];

  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/solaar"
    ];
  };
}
