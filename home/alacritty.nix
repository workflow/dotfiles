{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal = {
          family = "Fira Code Nerd Font";
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

      key_bindings = [
        { key = "Return"; mods = "Control|Super"; action = "SpawnNewInstance"; }
        # Enable me after 0.5.0 upgrade!
        # { key = "Escape"; mods = "Alt"; action = "ToggleViMode"; }
      ];

    };
  };
}
