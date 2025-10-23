{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    files = [
      ".config/pavucontrol.ini"
    ];
  };

  home.packages = [
    pkgs.pavucontrol
  ];
}
