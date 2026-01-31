{...}: {
  flake.modules.homeManager.discord = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/discord"
      ];
    };

    programs.discord = {
      enable = true;
    };
  };
}
