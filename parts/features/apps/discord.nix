{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.discord = {lib, ...}: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/discord"
      ];
    };

    programs.discord = {
      enable = true;
    };
  };
}
