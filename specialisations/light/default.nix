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
      # Aichat Light Theme
      home.sessionVariables = {
        AICHAT_LIGHT_THEME = 1;
      };

      # Dunst
      services.dunst.iconTheme.name = lib.mkForce "Papirus-Light";

      # GTK
      gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = lib.mkForce false;

      # QT
      qt.enable = lib.mkForce false;

      # Neovim
      programs.neovim = {
        extraLuaConfig = ''
          -- Override lualine theme for light mode
          if require('lualine') then
            local lualine_config = require('lualine').get_config()
            lualine_config.options.theme = 'gruvbox-light'
            require('lualine').setup(lualine_config)
          end
        '';
      };

      # Rofi
      programs.rofi = {
        theme = lib.mkOverride 49 "gruvbox-light-soft";
      };

      # Sway
      wayland.windowManager.sway.config.bars = lib.mkForce [
        (
          {
            fonts = {
              names = ["Fira Code" "Font Awesome 6 Free"];
              size = 8.5; # Aligns separators properly, see https://github.com/greshake/i3status-rust/issues/246k
            };
            position = "bottom";
            statusCommand = "${pkgs.unstable.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          }
          // config.specialisation.light.configuration.home-manager.users.farlion.lib.stylix.sway.bar
        )
      ];
      programs.i3status-rust.bars.default = {
        theme = lib.mkForce "ctp-latte";
      };

      stylix.targets = {
        # Neovim
        neovim.enable = lib.mkForce true;
      };
    };
  };
}
