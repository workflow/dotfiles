{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/lnav"
    ];
  };

  home.packages = [
    pkgs.lnav
  ];
}
