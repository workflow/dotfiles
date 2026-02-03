# Pulse Audio Volume Control GUI
{...}: {
  flake.modules.homeManager.pavucontrol = {lib, osConfig, pkgs, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      files = [
        ".config/pavucontrol.ini"
      ];
    };

    home.packages = [
      pkgs.pavucontrol
    ];
  };
}
