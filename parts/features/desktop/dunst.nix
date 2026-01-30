{...}: {
  flake.modules.homeManager.dunst = {pkgs, ...}: {
    services.dunst = {
      enable = true;

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      settings = {
        global = {
          browser = "brave";
          dmenu = "fuzzel --dmenu";
          follow = "mouse";
        };
      };
    };
  };
}
