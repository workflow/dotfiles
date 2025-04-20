{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/lnav"
    ];
  };

  home.packages = [
    pkgs.lnav
  ];
}
