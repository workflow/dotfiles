{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/Signal"
    ];
  };

  home.packages = [
    pkgs.signal-desktop
  ];
}
