{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/freerdp" # server keys connected to
      ".config/dconf" # gnome-connections uses dconf/GSettings for storing connection profiles and settings
    ];
  };

  home.packages = [
    pkgs.gnome-connections
  ];
}
