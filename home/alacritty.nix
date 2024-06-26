{...}: {
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal = {
          family = "FiraCode Nerd Font";
        };
        size = 8;
      };

      # Colors (Modified Gruvbox dark)
      colors = {
        # Default colors
        primary = {
          # hard contrast: background = '#1d2021'
          background = "#1e272b";
          # soft contrast: background = '#32302f'
          foreground = "#ead49b";
        };

        # Normal colors
        normal = {
          black = "#282828";
          red = "#cc241d";
          green = "#98971a";
          yellow = "#d79921";
          blue = "#458588";
          magenta = "#b16286";
          cyan = "#689d6a";
          white = "#a89984";
        };
        # Bright colors
        bright = {
          black = "#928374";
          red = "#fb4934";
          green = "#b8bb26";
          yellow = "#fabd2f";
          blue = "#83a598";
          magenta = "#d3869b";
          cyan = "#8ec07c";
          white = "#ebdbb2";
        };
      };

      cursor = {
        vi_mode_style = {
          shape = "Beam";
          blinking = "Always";
        };
      };

      keyboard.bindings = [
        {
          key = "Return";
          mods = "Control|Super";
          action = "SpawnNewInstance";
        }
        {
          key = "Escape";
          mods = "Alt";
          action = "ToggleViMode";
        }
        {
          key = "Semicolon";
          mode = "Vi|~Search";
          action = "Right";
        }
        {
          key = "L";
          mode = "Vi|~Search";
          action = "Up";
        }
        {
          key = "K";
          mode = "Vi|~Search";
          action = "Down";
        }
        {
          key = "J";
          mode = "Vi|~Search";
          action = "Left";
        }
        {
          key = 53;
          mode = "Vi|~Search";
          mods = "Shift";
          action = "SearchBackward";
        }
      ];

      env = {
        # Better color support in some apps
        TERM = "xterm-256color";
      };

      scrolling = {
        history = 100000;
      };
    };
  };
}
