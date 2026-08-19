# Cast media to UPnP/DLNA renderers (e.g. LG webOS TVs)
{...}: {
  flake.modules.nixos.go2tv = {
    networking.firewall.allowedTCPPorts = [
      3500 # go2tv media server + UPnP event callbacks
    ];
  };

  flake.modules.homeManager.go2tv = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/go2tv"
      ];
    };

    home.packages = [
      pkgs.go2tv
    ];
  };
}
