{pkgs, ...}: {
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
      };

      ignore_flameshot_warning = {
        appname = "flameshot";
        body = "*implemented based on wlroots*";
        skip_display = true;
      };
    };
  };
}
