{...}: {
  flake.modules.homeManager.lnav = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".config/lnav"];
    };

    home.packages = [pkgs.lnav];
  };
}
