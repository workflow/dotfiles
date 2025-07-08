{...}: {
  programs.alacritty = {
    enable = true;

    settings = {
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

      window = {
        padding = {
          x = 5;
          y = 4;
        };
      };
    };
  };
}
