{...}: {
  flake.modules.homeManager.gimp = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/GIMP"
        ".cache/gimp"
      ];
    };

    home.packages = [
      pkgs.gimp
    ];
  };
}
