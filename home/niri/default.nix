{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
with lib; let
  isFlexbox = osConfig.networking.hostName == "flexbox";
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

  locker = "${pkgs.bash}/bin/bash -c '${pkgs.procps}/bin/pgrep -x swaylock || ${pkgs.swaylock-effects}/bin/swaylock --daemonize'";
  suspender = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";

  # Wallpaper, until stylix supports it :)
  wallpaperSetter = pkgs.writeShellApplication {
    name = "niri-set-wallpaper";
    runtimeInputs = [pkgs.swaybg pkgs.procps];
    text = builtins.readFile ./scripts/niri-set-wallpaper.sh;
  };

  # Window Picker a la rofi
  windowPicker = pkgs.writeShellApplication {
    name = "niri-pick-window";
    runtimeInputs = [pkgs.niri pkgs.unstable.fuzzel pkgs.jq];
    text = builtins.readFile ./scripts/niri-pick-window.sh;
  };

  # Calculator via fuzzel + qalc
  fuzzelCalc = pkgs.writeShellApplication {
    name = "niri-qalc";
    runtimeInputs = [pkgs.unstable.fuzzel pkgs.libqalculate pkgs.wl-clipboard pkgs.libnotify];
    text = builtins.readFile ./scripts/niri-qalc.sh;
  };

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
  home.packages = with pkgs; [
    brightnessctl # For brightness +/- keys
    qt5.qtwayland # Needed for QT_QPA_PLATFORM=wayland
    playerctl # For play/pause etc... controlling media players that implement MPRIS
    swaybg # Minmal wallpaper setter for Sway
    wallpaperSetter # Specialization-aware wallpaper setting
    windowPicker # niri-pick-window
    xwayland-satellite # For apps that need Xwayland
    fuzzelCalc # niri-qalc
  ];

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      debug = false;
      show-failed-attempts = true;
      ignore-empty-password = true;
      screenshots = true;
      effect-pixelate = 10; # Pixellation level (higher = more pixelated)
      effect-blur = "7x5";
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${locker}";
      }
      {
        event = "lock";
        command = "${locker}";
      }
    ];
    timeouts = [
      {
        timeout = 360;
        command = "${locker}";
      }
      {
        timeout = 370;
        command = "/run/current-system/sw/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.coreutils}/bin/sleep 1; /run/current-system/sw/bin/niri msg action power-on-monitors";
      }
      {
        timeout = 1800;
        command = "${suspender}";
      }
    ];
  };

  # Fix swayidle service dependencies for Niri/Wayland session
  # Fails to boot with default settings
  systemd.user.services.swayidle = {
    Unit = {
      After = ["niri.service" "graphical-session.target"];
      Wants = ["graphical-session.target"];
      # Override the default ConditionEnvironment to be less strict
      ConditionEnvironment = lib.mkForce [];
    };
    Service = {
      # Add a small delay to double-ensure Wayland display is ready
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
      # Restart the service if it fails (useful for session restarts)
      Restart = lib.mkForce "on-failure";
      RestartSec = "5";
    };
  };

  programs.wlogout = {
    enable = true;
  };

  # Wallpaper, until stylix supports it :)
  home.file.".local/share/wallpapers/gruvbox-light.png".source = ./wallpapers/gruvbox-light-rainbow.png;
  home.file.".local/share/wallpapers/gruvbox-dark.png".source = ./wallpapers/gruvbox-dark-rainbow.png;

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
          options = "eurosign:e,terminate:ctrl_alt_bksp";
        };
      };
      touchpad = {
        dwt = true; # Disable touchpad while typing
        disabled-on-external-mouse = false;
        natural-scroll = false;
        tap = true;
        tap-button-map = "left-right-middle";
      };
      focus-follows-mouse.enable = true;
    };

    # Cursor Settings
    cursor = {
      hide-after-inactive-ms = 3000;
      hide-when-typing = true;
    };

    # Startup
    spawn-at-startup = [
      {command = ["${pkgs.bash}/bin/bash" "-c" "sleep 10 && systemctl --user restart xdg-desktop-portal"];} # Hacks around a timing prob with xdg-desktop-portal on first boot, see https://github.com/sodiboo/niri-flake/issues/509
      {command = ["systemctl" "--user" "restart" "kanshi"];}
      {command = ["systemctl" "--user" "restart" "app-blueman@autostart"];}
      {command = ["systemctl" "--user" "start" "gnome-keyring-ssh"];} # Start GNOME Keyring SSH agent
      {command = ["obsidian"];}
      {command = ["ytmdesktop"];}
      {command = ["${pkgs.bash}/bin/bash" "-c" "sleep 2 && todoist-electron --ozone-platform-hint=auto"];} # Hack timing problem with Todoist not coming up after boot
      {command = ["seahorse"];} # To unlock keyring
      {command = ["${wallpaperSetter}/bin/niri-set-wallpaper"];} # Set wallpaper
      {command = ["wlsunset-waybar"];}
      {command = ["zen"];}
    ];

    # Window Rules
    # Find app_id or title with `niri msg windows`
    window-rules = [
      {
        matches = [
          {
            app-id = "^zen-beta$";
          }
        ];
        open-on-workspace = " a";
      }
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
        ];
        open-floating = true;
      }
      # Block from screencasting
      {
        matches = [
          {app-id = "^Bitwarden$";}
          {app-id = "^com.obsproject.Studio$";}
        ];
        block-out-from = "screen-capture";
      }
      # Screen Cast Target Highlight
      {
        matches = [
          {is-window-cast-target = true;}
        ];
        border = {
          active = {color = "#f38ba8";};
          inactive = {color = "#7d0d2d";};
        };
        shadow = {
          color = "#7d0d2d70";
        };
        tab-indicator = {
          active = {color = "#f38ba8";};
          inactive = {color = "#7d0d2d";};
        };
      }
    ];

    # Named Workspaces
    workspaces = {
      "aa" = {
        name = " a";
        open-on-output = rightScreen;
      };
      "b1" = {
        name = " 1";
        open-on-output = mainScreen;
      };
      "c2" = {
        name = " 2";
        open-on-output = mainScreen;
      };
      "d3" = {
        name = " 3";
        open-on-output = rightScreen;
      };
      "e4" = {
        name = " 4";
        open-on-output = leftScreen;
      };
      "f5" = {
        name = " 5";
        open-on-output = mainScreen;
      };
      "g6" = {
        name = " 6";
        open-on-output = mainScreen;
      };
      "h7" = {
        name = " 7";
        open-on-output = rightScreen;
      };
      "i8" = {
        name = " 8";
        open-on-output = mainScreen;
      };
      "j9" = {
        name = " 9";
        open-on-output = leftScreen;
      };
      "k10" = {
        name = " 10";
        open-on-output = mainScreen;
      };
    };

    # Layout
    layout = {
      border = {
        enable = true;
        width = 2; # Default 4
      };

      default-column-width.proportion = 1. / 2.;

      gaps = 4; # Default 16

      preset-column-widths = [
        {proportion = 1. / 2.;}
        {proportion = 1. / 3.;}
        {proportion = 2. / 3.;}
      ];

      shadow = {
        enable = true;
      };
    };

    # Style
    prefer-no-csd = true;

    # Animations
    animations = {
      workspace-switch.enable = false;
    };

    # Keybindings
    hotkey-overlay.skip-at-startup = true;
    binds = with config.lib.niri.actions;
      lib.attrsets.mergeAttrsList [
        {
          "Mod+Shift+Slash".action = show-hotkey-overlay;

          "Mod+Return".action = spawn "alacritty";
          "Mod+Return".hotkey-overlay.title = "Open a Terminal: alacritty";
          "Mod+D".action = spawn "fuzzel";
          "Mod+D".hotkey-overlay.title = "Run an Application: fuzzel";
          "Mod+Shift+D".action = spawn "${windowPicker}/bin/niri-pick-window";
          "Mod+Shift+D".hotkey-overlay.title = "Pick a Window: niri-pick-window";
          "Mod+Shift+X".action = spawn-sh "swaylock --daemonize && niri msg action power-off-monitors";
          "Mod+Shift+X".hotkey-overlay.title = "Lock screen and turn off monitors";
          "Mod+Shift+z".action = power-off-monitors;
          "Mod+Shift+z".hotkey-overlay.title = "Power off Monitors";

          "XF86AudioRaiseVolume".action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
          "XF86AudioRaiseVolume".allow-when-locked = true;
          "XF86AudioLowerVolume".action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          "XF86AudioLowerVolume".allow-when-locked = true;
          "XF86AudioMute".action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMute".allow-when-locked = true;
          "XF86AudioMicMute".action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "XF86AudioMicMute".allow-when-locked = true;
          "XF86MonBrightnessUp".action = spawn-sh "brightnessctl --class=backlight set 10%+";
          "XF86MonBrightnessUp".allow-when-locked = true;

          "XF86MonBrightnessDown".action = spawn-sh "brightnessctl --class=backlight set 10%-";
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

          "Mod+C".action = center-column;
          "Mod+Ctrl+C".action = center-visible-columns;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Equal".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Equal".action = set-window-height "+10%";

          "Mod+V".action = toggle-window-floating;
          "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

          "Mod+Shift+W".action = spawn-sh (
            builtins.concatStringsSep "; " [
              "systemctl --user restart waybar.service"
              "${wallpaperSetter}/bin/niri-set-wallpaper"
            ]
          );
          "Mod+Shift+W".hotkey-overlay.title = "Restart Waybar";

          "Mod+Space".action = switch-layout "next";
          "Mod+Shift+Space".action = switch-layout "prev";

          "Print".action = screenshot;
          "Print".hotkey-overlay.title = "Screenshot via Niri";
          "Mod+Print".action = spawn "satty-screenshot";
          "Mod+Print".hotkey-overlay.title = "Screenshot via Satty";
          "Mod+Shift+Print".action.screenshot-screen = [];
          "Mod+Shift+Print".hotkey-overlay.title = "Instant Screenshot";

          # Applications such as remote-desktop clients and software KVM switches may
          # request that niri stops processing the keyboard shortcuts defined here
          # so they may, for example, forward the key presses as-is to a remote machine.
          # It's a good idea to bind an escape hatch to toggle the inhibitor,
          # so a buggy application can't hold your session hostage.
          #
          # The allow-inhibiting=false property can be applied to other binds as well,
          # which ensures niri always processes them, even when an inhibitor is active.
          "Mod+Shift+Escape".action = toggle-keyboard-shortcuts-inhibit;
          "Mod+Shift+Escape".allow-inhibiting = false;

          "Ctrl+Alt+Delete".action = quit;
        }

        {
          # Dynamic Cast ([G]rab Window or Screen)
          "Mod+G".action = set-dynamic-cast-window;
          "Mod+Shift+G".action = set-dynamic-cast-monitor;
          "Mod+Delete".action = clear-dynamic-cast-target;

          # Fancy Moving
          "Mod+Tab".action = focus-window-down-or-column-right;
          "Mod+Shift+Tab".action = focus-window-up-or-column-left;
        }
        {
          # Browser
          "Mod+b".action = spawn-sh (
            if isFlexbox
            then "brave --profile-directory='Default' --enable-features='VaapiVideoDecoder,VaapiVideoEncoder' --enable-raw-draw --password-store=seahorse"
            else "brave --profile-directory='Default' --password-store=seahorse"
          );
          "Mod+b".hotkey-overlay.hidden = true;
          "Mod+Shift+b".action = spawn "zen";
          "Mod+Shift+b".hotkey-overlay.hidden = true;
          "Mod+h".action = spawn-sh (
            if isFlexbox
            then "brave --profile-directory='Profile 1' --enable-features='VaapiVideoDecoder,VaapiVideoEncoder' --enable-raw-draw --password-store=seahorse"
            else "brave --profile-directory='Profile 1' --password-store=seahorse"
          );
          "Mod+h".hotkey-overlay.hidden = true;

          # Cliphist via fuzzel
          "Mod+p".action = spawn "cliphist-fuzzel-img";
          "Mod+p".hotkey-overlay.hidden = true;
          # Single item clearing
          "Mod+Shift+p".action = spawn-sh "cliphist list | fuzzel --dmenu | cliphist delete";
          "Mod+Shift+p".hotkey-overlay.hidden = true;

          # File Manager [n]avigate
          "Mod+n".action = spawn-sh "alacritty -e fish -ic lf";
          "Mod+n".hotkey-overlay.hidden = true;

          # Calcu[M]athlator
          "Mod+m".action = spawn "${fuzzelCalc}/bin/niri-qalc";
          "Mod+m".hotkey-overlay.title = "Calcu[M]athalor via qalculate";

          # Logout and Power Menu
          "Mod+Pause".action = spawn "wlogout";

          # Network ([W]ifi) Selection
          "Mod+w".action = spawn "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu";
          "Mod+w".hotkey-overlay.hidden = true;

          # Overview
          "Mod+o".action = toggle-overview;
          "Mod+o".repeat = false;

          # Rofi[e]moji
          "Mod+e".action = spawn "rofimoji";
          "Mod+e".hotkey-overlay.hidden = true;
          "Mod+Shift+e".action = spawn ["rofimoji" "--action" "clipboard"];
          "Mod+Shift+e".hotkey-overlay.hidden = true;

          # [S]ound Switcher
          "Mod+s".action = spawn "sound-switcher";
          "Mod+s".hotkey-overlay.hidden = true;
        }
      ];
  };
}
