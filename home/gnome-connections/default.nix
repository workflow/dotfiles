{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/freerdp" # RDP server certificates/keys
      ".config/dconf" # GNOME settings database (GSettings/dconf)
    ];
    files = [
      ".config/connections.db" # GNOME Connections connection profiles database
    ];
  };

  home.packages = [
    pkgs.gnome-connections
  ];
}
