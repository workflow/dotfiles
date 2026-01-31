{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.ansible = {lib, ...}: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [".ansible"];
    };
  };
}
