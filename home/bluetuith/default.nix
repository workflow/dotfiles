{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/bluetuith"
    ];
  };

  home.packages = [
    pkgs.bluetuith
  ];
}
