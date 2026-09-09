{...}: {
  flake.modules.homeManager.herdr = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".config/herdr"];
    };

    home.packages = [pkgs.unstable.herdr];
  };
}
