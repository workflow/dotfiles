{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/freerdp" # server keys connected to
      ".local/share/gnome-connections" # connection profiles and data
    ];
  };

  home.packages = [
    pkgs.gnome-connections
  ];
}
