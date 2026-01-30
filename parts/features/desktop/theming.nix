{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.nixos.theming = {
    pkgs,
    lib,
    ...
  }: {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
      cursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
      fonts = {
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        monospace = {
          package = pkgs.fira-code;
          name = "Fira Code";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        sizes = {
          applications = 9;
          desktop = 9;
          terminal = 8;
          popups = 9;
        };
      };
      image = ./theming/_wallpapers/gruvbox-dark-rainbow.png;
      polarity = "dark";
    };

    specialisation.light.configuration = {
      environment.etc."specialisation".text = "light";

      stylix = {
        base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
        image = lib.mkForce ./theming/_wallpapers/gruvbox-light-rainbow.png;
        polarity = lib.mkForce "light";
      };

      home-manager.users.farlion = {
        home.sessionVariables = {
          AICHAT_LIGHT_THEME = 1;
        };

        services.dunst.iconTheme.name = lib.mkForce "Papirus-Light";

        gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = lib.mkForce false;

        qt.enable = lib.mkForce false;

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

        stylix.targets = {
          neovim.enable = lib.mkForce true;
        };

        programs.k9s.settings.k9s.ui.skin = lib.mkForce "gruvbox-light";
      };
    };
  };

  flake.modules.homeManager.theming = {pkgs, ...}: {
    home.packages = [
      pkgs.papirus-icon-theme
    ];
    stylix = {
      iconTheme = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        light = "Papirus-Light";
        dark = "Papirus-Dark";
      };
      targets = {
        firefox = {
          profileNames = ["main"];
        };
        neovim.enable = false;
      };
    };
  };
}
