{
  config,
  lib,
  pkgs,
  ...
}: {
  specialisation.light.configuration = {
    environment.etc."specialisation".text = "light"; # this is for 'nh' to correctly recognise the specialisation

    # System
    stylix = {
      base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
      image = lib.mkForce ../../system/stylix/gruvbox-light-rainbow.png;
      polarity = lib.mkForce "light";
    };

    # Home Manager
    home-manager.users.farlion = {
      # GTK
      gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = lib.mkForce false;

      # QT
      qt.enable = lib.mkForce false;

      # Aichat Light Theme
      home.sessionVariables = {
        AICHAT_LIGHT_THEME = 1;
      };

      # i3
      xsession.windowManager.i3.config.bars = lib.mkForce [
        (
          {
            command = "${pkgs.i3-gaps}/bin/i3bar";
            fonts = {
              names = ["Fira Code" "Font Awesome 6 Free"];
              size = 9.0;
            };
            position = "bottom";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          }
          // config.specialisation.light.configuration.home-manager.users.farlion.lib.stylix.i3.bar
        )
      ];
      programs.i3status-rust.bars.default = {
        theme = lib.mkForce "ctp-latte";
      };

      # Rofi
      programs.rofi = {
        theme = lib.mkForce null;
      };

      stylix.targets = {
        # Neovim
        neovim.enable = lib.mkForce true;

        # Rofi
        rofi.enable = lib.mkForce true;
      };
    };
  };
}
