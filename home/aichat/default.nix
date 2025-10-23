{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/aichat"
    ];
  };
  home.packages = [
    pkgs.unstable.aichat
  ];
}
