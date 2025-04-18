{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.devenv
  ];

  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".local/share/devenv"
    ];
  };
}
