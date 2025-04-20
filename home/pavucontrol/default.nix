{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    files = [
      "pavucontrol.ini"
    ];
  };

  home.packages = [
    pkgs.pavucontrol
  ];
}
