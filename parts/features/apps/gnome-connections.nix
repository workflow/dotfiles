{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.gnome-connections = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/freerdp"
        ".config/dconf"
      ];
      files = [".config/connections.db"];
    };

    home.packages = [pkgs.gnome-connections];
  };
}
