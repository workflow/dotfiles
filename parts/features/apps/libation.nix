{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.libation = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        "Libation"
        ".local/share/Libation"
      ];
    };

    home.packages = [pkgs.libation];
  };
}
