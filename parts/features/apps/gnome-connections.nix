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
      ];
      files = [".config/connections.db"]; # GNOME Connections connection profiles database
    };

    home.packages = [pkgs.gnome-connections];
  };
}
