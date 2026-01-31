{...}: {
  flake.modules.homeManager.networkmanager-dmenu = {pkgs, ...}: {
    home.packages = [pkgs.networkmanager_dmenu];
    xdg.configFile."networkmanager-dmenu/config.ini".source = ./_config.ini;
  };
}
