{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/aichat"
    ];
  };
  home.packages = [
    pkgs.unstable.aichat
  ];
}
