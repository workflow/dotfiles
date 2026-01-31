{...}: {
  flake.modules.homeManager.isd = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/isd_tui"
        ".local/share/isd_tui"
        ".cache/isd_tui"
      ];
    };

    home.packages = [pkgs.isd];
  };
}
