{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.dconf = {lib, ...}: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/dconf"
      ];
    };
  };
}
