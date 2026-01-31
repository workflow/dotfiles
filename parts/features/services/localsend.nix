{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.nixos.localsend = {...}: {
    programs.localsend.enable = true;
  };

  flake.modules.homeManager.localsend = {lib, ...}: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [".local/share/org.localsend.localsend_app"];
    };
  };
}
