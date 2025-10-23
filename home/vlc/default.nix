{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/vlc"
      ".local/share/vlc"
    ];
  };

  home.packages = [
    pkgs.vlc
  ];
}
