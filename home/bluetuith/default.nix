{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/bluetuith"
    ];
  };

  home.packages = [
    pkgs.bluetuith
  ];
}
