{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/YouTube Music Desktop App"
    ];
  };

  home.packages = [
    pkgs.ytmdesktop
  ];
}
