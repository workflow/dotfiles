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
      {command = ["seahorse"];}
      {command = ["systemctl" "--user" "restart" "kanshi"];}
      {command = ["wlsunset-waybar"];}
    ];

    # Window Rules
    window-rules = [
      {
        matches = [
          {app-id = "^signal$";}
          {app-id = "^teams-for-linux$";}
          {app-id = "^org.telegram.desktop$";}
        ];
        open-on-workspace = "8";
      }
      {
        matches = [
          {app-id = "^YouTube Music Desktop App$";}
          {app-id = "^Todoist$";}
        ];
        open-on-workspace = "9";
      }
      {
        matches = [
          {app-id = "^obsidian$";}
        ];
        open-on-workspace = "19";
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
      "8" = {name = "8: ";};
      "9" = {name = "9: ";};
      "10" = {name = "10: ";};
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
    binds = with config.lib.niri.actions; let
      sh = spawn "sh" "-c";
    in
      lib.attrsets.mergeAttrsList [
        {
          "Mod+T".action = spawn "alacritty";
          "Mod+O".action = show-hotkey-overlay;
          "Mod+D".action = spawn "fuzzel";
          "Mod+W".action = sh (
            builtins.concatStringsSep "; " [
              "systemctl --user restart waybar.service"
            ]
          );

          "Mod+L".action = spawn "blurred-locker";

          "Mod+Shift+S".action = screenshot;
          "Print".action.screenshot-screen = [];
          "Mod+Print".action = screenshot-window;

          "Mod+Insert".action = set-dynamic-cast-window;
          "Mod+Shift+Insert".action = set-dynamic-cast-monitor;
          "Mod+Delete".action = clear-dynamic-cast-target;

          "XF86AudioRaiseVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
          "XF86AudioLowerVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          "XF86AudioMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

          "XF86MonBrightnessUp".action = sh "brightnessctl set 10%+";
          "XF86MonBrightnessDown".action = sh "brightnessctl set 10%-";

          "Mod+Q".action = close-window;

          "Mod+Space".action = toggle-column-tabbed-display;

          "XF86AudioNext".action = focus-column-right;
          "XF86AudioPrev".action = focus-column-left;

          "Mod+Tab".action = focus-window-down-or-column-right;
          "Mod+Shift+Tab".action = focus-window-up-or-column-left;
        }
        (binds {
          suffixes."Left" = "column-left";
          suffixes."j" = "column-left";
          suffixes."Down" = "window-down";
          suffixes."Up" = "window-up";
          suffixes."Right" = "column-right";
          suffixes."semicolon" = "column-right";
          prefixes."Mod" = "focus";
          prefixes."Mod+Ctrl" = "move";
          prefixes."Mod+Shift" = "focus-monitor";
          prefixes."Mod+Shift+Ctrl" = "move-window-to-monitor";
          substitutions."monitor-column" = "monitor";
          substitutions."monitor-window" = "monitor";
        })
        {
          "Mod+V".action = switch-focus-between-floating-and-tiling;
          "Mod+Shift+V".action = toggle-window-floating;
        }
        (binds {
          suffixes."Home" = "first";
          suffixes."End" = "last";
          prefixes."Mod" = "focus-column";
          prefixes."Mod+Ctrl" = "move-column-to";
        })
        (binds {
          suffixes."U" = "workspace-down";
          suffixes."I" = "workspace-up";
          prefixes."Mod" = "focus";
          prefixes."Mod+Ctrl" = "move-window-to";
          prefixes."Mod+Shift" = "move";
        })
        # Workspace bindings matching Sway config
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
          prefixes."Mod+Ctrl" = "move-window-to";
        })
        # # Additional workspace bindings
        # {
        #   "Mod+0".action = focus-workspace 10;
        #   "Mod+Ctrl+0".action = move-window-to-workspace 10;
        #
        #   # Alt+number bindings for workspaces 11-20
        #   "Mod+Alt+1".action = focus-workspace 11;
        #   "Mod+Alt+2".action = focus-workspace 12;
        #   "Mod+Alt+3".action = focus-workspace 13;
        #   "Mod+Alt+4".action = focus-workspace 14;
        #   "Mod+Alt+5".action = focus-workspace 15;
        #   "Mod+Alt+6".action = focus-workspace 16;
        #   "Mod+Alt+7".action = focus-workspace 17;
        #   "Mod+Alt+8".action = focus-workspace 18;
        #   "Mod+Alt+9".action = focus-workspace 19;
        #   "Mod+Alt+0".action = focus-workspace 20;
        #
        #   "Mod+Ctrl+Alt+1".action = move-window-to-workspace 11;
        #   "Mod+Ctrl+Alt+2".action = move-window-to-workspace 12;
        #   "Mod+Ctrl+Alt+3".action = move-window-to-workspace 13;
        #   "Mod+Ctrl+Alt+4".action = move-window-to-workspace 14;
        #   "Mod+Ctrl+Alt+5".action = move-window-to-workspace 15;
        #   "Mod+Ctrl+Alt+6".action = move-window-to-workspace 16;
        #   "Mod+Ctrl+Alt+7".action = move-window-to-workspace 17;
        #   "Mod+Ctrl+Alt+8".action = move-window-to-workspace 18;
        #   "Mod+Ctrl+Alt+9".action = move-window-to-workspace 19;
        #   "Mod+Ctrl+Alt+0".action = move-window-to-workspace 20;
        #
        #   # Workspace 'c' binding (moved from center-column to avoid conflict)
        #   "Mod+Shift+C".action = focus-workspace "c";
        #   "Mod+Ctrl+Shift+C".action = move-window-to-workspace "c";
        # }
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
