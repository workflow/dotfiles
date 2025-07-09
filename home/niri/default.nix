{
  config,
  lib,
  ...
}:
with lib; let
  binds = {
    suffixes,
    prefixes,
    substitutions ? {},
  }: let
    replacer = replaceStrings (attrNames substitutions) (attrValues substitutions);
    format = prefix: suffix: let
      actual-suffix =
        if isList suffix.action
        then {
          action = head suffix.action;
          args = tail suffix.action;
        }
        else {
          inherit (suffix) action;
          args = [];
        };

      action = replacer "${prefix.action}-${actual-suffix.action}";
    in {
      name = "${prefix.key}+${suffix.key}";
      value.action.${action} = actual-suffix.args;
    };
    pairs = attrs: fn:
      concatMap (
        key:
          fn {
            inherit key;
            action = attrs.${key};
          }
      ) (attrNames attrs);
  in
    listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [(format prefix suffix)])));
in {
  programs.niri.settings = {
    # Environment
    environment = {
      NIXOS_OZONE_WL = "1"; # Enable Ozone-Wayland for Electron apps and Chromium, see https://nixos.wiki/wiki/Wayland
    };

    # Input Settings
    input = {
      keyboard = {
        xkb = {
          layout = "us,de,ua,pt";
          options = "grp:ctrls_toggle,eurosign:e,caps:escape_shifted_capslock,terminate:ctrl_alt_bksp";
        };
      };
      touchpad = {
        tap = true;
        tap-button-map = "left-right-middle";
      };
    };

    # Cursor Settings
    cursor = {
      hide-after-inactive-ms = 3000;
      hide-when-typing = true;
    };

    # Startup
    spawn-at-startup = [
      {command = ["ytmdesktop"];}
      {command = ["todoist-electron" "--ozone-platform-hint=auto"];}
      {command = ["systemctl" "--user" "restart" "kanshi"];}
      {command = ["systemctl" "--user" "start" "waybar"];}
      {command = ["wlsunset-waybar"];}
    ];

    # Window Rules
    window-rules = [
      {
        matches = [
          {app-id = "^Todoist$";}
          {app-id = "^obsidian$";}
        ];
        open-on-workspace = " 7";
      }
      {
        matches = [
          {app-id = "^signal$";}
          {app-id = "^teams-for-linux$";}
          {app-id = "^org.telegram.desktop$";}
        ];
        open-on-workspace = " 8";
      }
      {
        matches = [
          {app-id = "^YouTube Music Desktop App$";}
          {app-id = "^Todoist$";}
        ];
        open-on-workspace = " 9";
      }
      # Floating windows
      {
        matches = [
          {title = ".*Pavucontrol.*";}
          {title = ".*zoom.*";}
          {app-id = "flameshot";}
        ];
        open-floating = true;
      }
    ];

    # Named Workspaces
    workspaces = {
      "aa" = {name = " a";};
      "b1" = {name = " 1";};
      "c2" = {name = " 2";};
      "d3" = {name = " 3";};
      "e4" = {name = " 4";};
      "f5" = {name = " 5";};
      "g6" = {name = " 6";};
      "h7" = {name = " 7";};
      "i8" = {name = " 8";};
      "j9" = {name = " 9";};
      "k10" = {name = " 10";};
    };

    # Layout
    layout = {
      gaps = 4; # Default 16

      border = {
        enable = true;
        width = 2; # Default 4
      };

      shadow = {
        enable = true;
      };
    };

    # Style
    prefer-no-csd = true;

    # Keybindings
    hotkey-overlay.skip-at-startup = true;
    binds = with config.lib.niri.actions; let
      sh = spawn "sh" "-c";
    in
      lib.attrsets.mergeAttrsList [
        {
          "Mod+Shift+Slash".action = show-hotkey-overlay;

          "Mod+Return".action = spawn "alacritty";
          "Mod+Return".hotkey-overlay.title = "Open a Terminal: alacritty";
          "Mod+D".action = spawn "fuzzel";
          "Mod+D".hotkey-overlay.title = "Run an Application: fuzzel";
          "Mod+Shift+X".action = spawn "swaylock";
          "Mod+Shift+X".hotkey-overlay.title = "Lock the screen: swaylock";

          "XF86AudioRaiseVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
          "XF86AudioRaiseVolume".allow-when-locked = true;
          "XF86AudioLowerVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          "XF86AudioLowerVolume".allow-when-locked = true;
          "XF86AudioMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMute".allow-when-locked = true;
          "XF86AudioMicMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "XF86AudioMicMute".allow-when-locked = true;
          "XF86MonBrightnessUp".action = sh "brightnessctl --class=backlight set 10%+";
          "XF86MonBrightnessUp".allow-when-locked = true;

          "XF86MonBrightnessDown".action = sh "brightnessctl --class=backlight set 10%-";
          "XF86MonBrightnessDown".allow-when-locked = true;

          "Mod+Shift+Q".action = close-window;
          "Mod+Shift+Q".repeat = false;
        }
        (binds {
          suffixes."Left" = "column-left";
          suffixes."j" = "column-left";
          suffixes."Down" = "window-down";
          suffixes."k" = "window-down";
          suffixes."Up" = "window-up";
          suffixes."l" = "window-up";
          suffixes."Right" = "column-right";
          suffixes."semicolon" = "column-right";
          prefixes."Mod" = "focus";
          prefixes."Mod+Ctrl" = "move";
          prefixes."Mod+Shift" = "focus-monitor";
          prefixes."Mod+Shift+Ctrl" = "move-window-to-monitor";
          substitutions."monitor-column" = "monitor";
          substitutions."monitor-window" = "monitor";
        })
        (binds {
          suffixes."Home" = "first";
          suffixes."End" = "last";
          prefixes."Mod" = "focus-column";
          prefixes."Mod+Ctrl" = "move-column-to";
        })
        (binds {
          suffixes."U" = "workspace-down";
          suffixes."Page_Down" = "workspace-down";
          suffixes."I" = "workspace-up";
          suffixes."Page_Up" = "workspace-up";
          prefixes."Mod" = "focus";
          prefixes."Mod+Ctrl" = "move-window-to";
          prefixes."Mod+Shift" = "move";
        })
        (binds {
          suffixes = builtins.listToAttrs (
            map (n: {
              name = toString n;
              value = [
                "workspace"
                n
              ];
            }) (range 1 9)
          );
          prefixes."Mod" = "focus";
          prefixes."Mod+Ctrl" = "move-columnt-to-workspace";
        })
        {
          "Mod+W".action = sh (
            builtins.concatStringsSep "; " [
              "systemctl --user restart waybar.service"
            ]
          );

          "Mod+Shift+S".action = screenshot;
          "Print".action.screenshot-screen = [];
          "Mod+Print".action = screenshot-window;

          "Mod+Insert".action = set-dynamic-cast-window;
          "Mod+Shift+Insert".action = set-dynamic-cast-monitor;
          "Mod+Delete".action = clear-dynamic-cast-target;

          "Mod+Space".action = toggle-column-tabbed-display;

          "XF86AudioNext".action = focus-column-right;
          "XF86AudioPrev".action = focus-column-left;

          "Mod+Tab".action = focus-window-down-or-column-right;
          "Mod+Shift+Tab".action = focus-window-up-or-column-left;
        }
        {
          "Mod+V".action = switch-focus-between-floating-and-tiling;
          "Mod+Shift+V".action = toggle-window-floating;
        }
        {
          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;

          "Mod+R".action = switch-preset-column-width;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;
          "Mod+C".action = center-column;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Plus".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Plus".action = set-window-height "+10%";

          "Mod+Shift+Escape".action = toggle-keyboard-shortcuts-inhibit;
          "Mod+Shift+E".action = quit;
          "Mod+Shift+P".action = power-off-monitors;

          "Mod+Shift+Ctrl+T".action = toggle-debug-tint;
        }
      ];
  };
}
