{...}: {
  flake.modules.homeManager.cliphist = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".cache/cliphist"
      ];
    };

    services.cliphist = {
      enable = true;
      extraOptions = [
        "-max-dedupe-search"
        "10"
        "-max-items"
        "200"
      ];
    };

    home.packages = [pkgs.xdg-utils]; # For image copy/pasting
  };
}
