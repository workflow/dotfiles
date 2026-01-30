{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.obsidian = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/obsidian"
        "Obsidian"
      ];
    };

    home.packages = [
      pkgs.obsidian
    ];
  };
}
