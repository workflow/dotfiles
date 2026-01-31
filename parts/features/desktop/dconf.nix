{...}: {
  flake.modules.homeManager.dconf = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/dconf"
      ];
    };
  };
}
