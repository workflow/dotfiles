{ pkgs, ... }:
{
  services.dunst = {
    enable = true;

    iconTheme = {
      name = "Pop";
      package = pkgs.pop-gtk-theme;
      size = "16x16";
    };

    settings = {};
  };
}

