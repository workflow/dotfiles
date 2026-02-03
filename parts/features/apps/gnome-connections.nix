{...}: {
  flake.modules.homeManager.gnome-connections = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/freerdp" # RDP server certificates/keys
        ".config/dconf" # GNOME settings database (GSettings/dconf)
      ];
      files = [".config/connections.db"]; # GNOME Connections connection profiles database
    };

    home.packages = [pkgs.gnome-connections];
  };
}
