{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/mpv"
      ".cache/mpv"
    ];
  };

  home.packages = [
    pkgs.mpv
  ];
}
