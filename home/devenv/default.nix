{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".local/share/devenv"
    ];
  };

  home.packages = [
    pkgs.devenv
  ];
}
