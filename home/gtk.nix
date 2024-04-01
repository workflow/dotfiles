{ pkgs, ... }:
let
  nixpkgs-unstable = pkgs.unstable;

in
{
  gtk = {
    enable = true;
    font = {
      name = "Fira Code";
      size = 9;
    };
    iconTheme = {
      name = "Pop";
      package = nixpkgs-unstable.pop-icon-theme;
    };
    theme = {
      name = "Pop";
      package = pkgs.pop-gtk-theme;
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk3";
  };

  # https://wiki.archlinux.org/title/HiDPI
  home.sessionVariables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_ENABLE_HIGHDPI_SCALING = "1";
  };

}
