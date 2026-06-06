{...}: {
  flake.modules.nixos.steam = {...}: {
    programs.steam.enable = true;
  };

  flake.modules.homeManager.steam = {
    osConfig,
    lib,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".local/share/Steam"
        ".steam"
        ".config/Hades II"
      ];
    };
  };
}
