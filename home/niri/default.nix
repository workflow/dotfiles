{
  config,
  lib,
  osConfig,
  ...
}:
with lib; let
  isNumenor = osConfig.networking.hostName == "numenor";

  leftScreen =
    if isNumenor
    then "HDMI-A-2"
    else null;
  mainScreen =
    if isNumenor
    then "DP-1"
    else "eDP-1";
  rightScreen =
    if isNumenor
    then "HDMI-A-1"
    else null;

  niriBinds = {
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
  programs.niri.settings = rec {
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
      "aa" = {
        name = " a";
        open-on-output = "${rightScreen}";
      };
      "b1" = {
        name = " 1";
        open-on-output = "${mainScreen}";
      };
      "c2" = {
        name = " 2";
        open-on-output = "${mainScreen}";
      };
      "d3" = {
        name = " 3";
        open-on-output = "${rightScreen}";
      };
      "e4" = {
        name = " 4";
        open-on-output = "${leftScreen}";
      };
      "f5" = {
        name = " 5";
        open-on-output = "${mainScreen}";
      };
      "g6" = {
        name = " 6";
        open-on-output = "${mainScreen}";
      };
      "h7" = {
        name = " 7";
        open-on-output = "${rightScreen}";
      };
      "i8" = {
        name = " 8";
        open-on-output = "${mainScreen}";
      };
      "j9" = {
        name = " 9";
        open-on-output = "${leftScreen}";
      };
      "k10" = {
        name = " 10";
        open-on-output = "${mainScreen}";
      };
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
        (niriBinds {
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
          prefixes."Mod+Shift+Ctrl" = "move-workspace-to-monitor";
          substitutions."monitor-column" = "monitor";
          substitutions."monitor-window" = "monitor";
        })
        (niriBinds {
          suffixes."Home" = "first";
          suffixes."End" = "last";
          prefixes."Mod" = "focus-column";
          prefixes."Mod+Ctrl" = "move-column-to";
        })
        (niriBinds {
          suffixes."U" = "workspace-down";
          suffixes."Page_Down" = "workspace-down";
          suffixes."I" = "workspace-up";
          suffixes."Page_Up" = "workspace-up";
          prefixes."Mod" = "focus";
          prefixes."Mod+Ctrl" = "move-window-to";
          prefixes."Mod+Shift" = "move";
        })
        (niriBinds {
          suffixes = {
            "a" = ["workspace" "${workspaces.aa.name}"];
            "1" = ["workspace" "${workspaces.b1.name}"];
            "2" = ["workspace" "${workspaces.c2.name}"];
            "3" = ["workspace" "${workspaces.d3.name}"];
            "4" = ["workspace" "${workspaces.e4.name}"];
            "5" = ["workspace" "${workspaces.f5.name}"];
            "6" = ["workspace" "${workspaces.g6.name}"];
            "7" = ["workspace" "${workspaces.h7.name}"];
            "8" = ["workspace" "${workspaces.i8.name}"];
            "9" = ["workspace" "${workspaces.j9.name}"];
            "0" = ["workspace" "${workspaces.k10.name}"];
          };
          prefixes."Mod" = "focus";
          prefixes."Mod+Ctrl" = "move-column-to";
        })
        {
          "Mod+BracketLeft".action = consume-or-expel-window-left;
          "Mod+BracketRight".action = consume-or-expel-window-right;

          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;

          "Mod+R".action = switch-preset-column-width;
          "Mod+Shift+R".action = switch-preset-window-height;
          "Mod+Ctrl+R".action = reset-window-height;

          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;
          "Mod+Ctrl+F".action = expand-column-to-available-width;
        }
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

          "Mod+Tab".action = focus-window-down-or-column-right;
          "Mod+Shift+Tab".action = focus-window-up-or-column-left;
        }
        {
          "Mod+V".action = switch-focus-between-floating-and-tiling;
          "Mod+Shift+V".action = toggle-window-floating;
        }
        {
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
