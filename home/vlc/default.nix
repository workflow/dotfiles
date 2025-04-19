{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/vlc"
      ".local/share/vlc"
    ];
  };

  home.packages = [
    pkgs.vlc
  ];
}
