{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.variety
  ];

  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/variety"
    ];
  };
  home.file = {
    ".config/variety/variety.conf".source = ./variety.conf;
  };
}
