{...}: {
  flake.modules.homeManager.mpv = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/mpv"
        ".cache/mpv"
      ];
    };

    home.packages = [
      pkgs.mpv
    ];
  };
}
