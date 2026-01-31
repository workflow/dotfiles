{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.gtk-qt = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      files = [
        ".config/QtProject.conf"
      ];
    };

    gtk = {
      enable = true;
      gtk3 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };

    home.packages = with pkgs; [
      lxappearance
      libsForQt5.qt5ct
      qt6Packages.qt6ct
    ];

    home.sessionVariables = {
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_ENABLE_HIGHDPI_SCALING = "1";
    };
  };
}
