{...}: {
  flake.modules.homeManager.zoom = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      files = [
        ".config/zoom.conf"
        ".config/zoomus.conf"
      ];
      directories = [
        ".zoom"
        ".cache/zoom"
      ];
    };

    home.packages = [
      pkgs.zoom-us
    ];
  };
}
