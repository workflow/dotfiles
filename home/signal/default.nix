{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/Signal"
    ];
  };

  home.packages = [
    pkgs.signal-desktop
  ];
}
