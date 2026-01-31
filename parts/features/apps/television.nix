{...}: {
  flake.modules.homeManager.television = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/television/cable"
      ];
    };

    programs.television = {
      enable = true;
    };
    programs.nix-search-tv = {
      enable = true;
    };
  };
}
