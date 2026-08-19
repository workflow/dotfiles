# Cast All The Things - send media to Chromecast devices
{...}: {
  flake.modules.homeManager.catt = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/catt"
      ];
    };

    home.packages = [
      pkgs.catt
    ];
  };
}
