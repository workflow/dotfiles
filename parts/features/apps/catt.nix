# Cast All The Things - send media to Chromecast devices
{...}: {
  flake.modules.nixos.catt = {
    networking.firewall.allowedTCPPorts = [
      45114 # catt local media server
      45115 # catt subtitles server
    ];
  };

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
