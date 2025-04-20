{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/mpv"
      ".cache/mpv"
    ];
  };

  home.packages = [
    pkgs.mpv
  ];
}
