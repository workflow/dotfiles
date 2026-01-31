{...}: {
  flake.modules.homeManager.galaxy-buds-client = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".local/share/GalaxyBudsClient"];
    };

    home.packages = [pkgs.galaxy-buds-client];
  };
}
