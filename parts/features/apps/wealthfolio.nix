{...}: {
  flake.modules.homeManager.wealthfolio = {
    lib,
    osConfig,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".local/share/com.teymz.wealthfolio"
        ".local/share/Wealthfolio"
        ".config/com.teymz.wealthfolio"
      ];
    };

    home.packages = [pkgs.unstable.wealthfolio];
  };
}
