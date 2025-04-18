{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/networkmanager-dmenu"
    ];
  };

  home.packages = [pkgs.networkmanager_dmenu];
  xdg.configFile."networkmanager-dmenu/config.ini".source = ./config.ini;
}
