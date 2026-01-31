{...}: {
  flake.modules.homeManager.gnome-connections = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/freerdp"
        ".config/dconf"
      ];
      files = [".config/connections.db"];
    };

    home.packages = [pkgs.gnome-connections];
  };
}
