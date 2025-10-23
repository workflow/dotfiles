{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".local/share/devenv"
    ];
  };

  home.packages = [
    pkgs.devenv
  ];
}
