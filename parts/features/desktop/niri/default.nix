{...}: {
  flake.modules.homeManager.niri = {
    osConfig,
    config,
    lib,
    pkgs,
    ...
  }:
    with lib; let
      isNumenor = osConfig.dendrix.hostname == "numenor";
      isNvidia = osConfig.dendrix.hasNvidia;
      isLightTheme = osConfig.specialisation == {};

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
        text = builtins.readFile ./_scripts/niri-set-wallpaper.sh;
      };

      # Window Picker a la rofi
      windowPicker = pkgs.writeShellApplication {
        name = "niri-pick-window";
        runtimeInputs = [pkgs.niri pkgs.unstable.fuzzel pkgs.jq];
        text = builtins.readFile ./_scripts/niri-pick-window.sh;
      };

      # Calculator via fuzzel + qalc
      fuzzelCalc = pkgs.writeShellApplication {
        name = "niri-qalc";
        runtimeInputs = [pkgs.unstable.fuzzel pkgs.libqalculate pkgs.wl-clipboard pkgs.libnotify];
        text = builtins.readFile ./_scripts/niri-qalc.sh;
      };

      # Workspace reorderer - maintains logical order after moving workspaces between monitors
      workspaceReorderer = pkgs.writeShellApplication {
        name = "niri-reorder-workspaces";
        runtimeInputs = [pkgs.niri pkgs.jq];
        text = builtins.readFile ./_scripts/niri-reorder-workspaces.sh;
      };

      # Auto-column - consumes new windows into columns on vertical monitors
      autoColumn = pkgs.writeShellApplication {
        name = "niri-auto-column";
        runtimeInputs = [pkgs.niri pkgs.jq pkgs.coreutils];
        text = builtins.readFile ./_scripts/niri-auto-column.sh;
      };

      # Open a command and move its window to a workspace once title matches
      openOnWorkspace = pkgs.writeShellApplication {
        name = "niri-open-on-workspace";
        runtimeInputs = [pkgs.niri pkgs.jq];
        text = builtins.readFile ./_scripts/niri-open-on-workspace.sh;
      };

      yaml = pkgs.formats.yaml {};

      braveWorkProfileCmd =
        if isNvidia
        then "brave --profile-directory='Profile 1' --enable-features=VaapiVideoDecoder,VaapiVideoEncoder --password-store=seahorse"
        else "brave --profile-directory='Profile 1' --password-store=seahorse";

      whichKeyConfig = {
        font = "Fira Code 14";
        background =
          if isLightTheme
          then "#eff1f5d0"
          else "#282828d0";
        color =
          if isLightTheme
          then "#4c4f69"
          else "#ebdbb2";
        border =
          if isLightTheme
          then "#df8e1d"
          else "#fabd2f";
        separator = " → ";
        border_width = 2;
        corner_r = 8;
        padding = 12;
        anchor = "center";
        menu = [
          {key = "z"; desc = "Zen Browser"; cmd = "zen";}
          {key = "h"; desc = "Brave (Work)"; cmd = braveWorkProfileCmd;}
          {key = "l"; desc = "File Manager (lf)"; cmd = "alacritty -e fish -ic lf";}
          {key = "c"; desc = "Calculator"; cmd = "${fuzzelCalc}/bin/niri-qalc";}
          {key = "w"; desc = "WiFi"; cmd = "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu";}
          {key = "s"; desc = "Sound Switcher"; cmd = "sound-switcher";}
          {key = "C"; desc = "Clipboard Delete"; cmd = "bash -c 'cliphist list | fuzzel --dmenu | cliphist delete'";}
          {
            key = "n";
            desc = "Niri";
            submenu = [
              {key = "R"; desc = "Preset Window Height"; cmd = "niri msg action switch-preset-window-height";}
              {key = "h"; desc = "Reset Window Height"; cmd = "niri msg action reset-window-height";}
              {key = "c"; desc = "Center Column"; cmd = "niri msg action center-column";}
              {key = "C"; desc = "Center Visible Columns"; cmd = "niri msg action center-visible-columns";}
              {key = "minus"; desc = "Column Width -10%"; cmd = "niri msg action set-column-width -- -10%";}
              {key = "equal"; desc = "Column Width +10%"; cmd = "niri msg action set-column-width -- +10%";}
              {key = "v"; desc = "Toggle Floating"; cmd = "niri msg action toggle-window-floating";}
              {key = "V"; desc = "Focus Floating/Tiling"; cmd = "niri msg action switch-focus-between-floating-and-tiling";}
              {key = "q"; desc = "Quit Niri"; cmd = "niri msg action quit";}
              {key = "Tab"; desc = "Focus Next Window/Column"; cmd = "niri msg action focus-window-down-or-column-right";}
            ];
          }
          {
            key = "k";
            desc = "Keyboard";
            submenu = [
              {key = "n"; desc = "Next Layout"; cmd = "niri msg action switch-layout next";}
              {key = "p"; desc = "Prev Layout"; cmd = "niri msg action switch-layout prev";}
              {key = "u"; desc = "US"; cmd = "niri msg action switch-layout 0";}
            ];
          }
          {
            key = "o";
            desc = "OBS";
            submenu = [
              {key = "m"; desc = "Main Scene"; cmd = "obs-main-scene";}
              {key = "s"; desc = "Screensharing"; cmd = "obs-screensharing";}
              {key = "c"; desc = "Catcam Toggle"; cmd = "obs-catcam-toggle";}
              {key = "r"; desc = "Recording Toggle"; cmd = "obs-recording-toggle";}
              {key = "p"; desc = "Recording Pause"; cmd = "obs-recording-pause";}
              {key = "w"; desc = "Webcam Toggle"; cmd = "obs-webcam-toggle";}
            ];
          }
          {
            key = "d";
            desc = "Display";
            submenu = [
              {key = "z"; desc = "Magnifier"; cmd = "hyprmagnifier";}
              {key = "o"; desc = "Power Off Monitors"; cmd = "niri msg action power-off-monitors";}
              {key = "r"; desc = "Restart Waybar + Wallpaper"; cmd = "systemctl --user restart waybar.service; ${wallpaperSetter}/bin/niri-set-wallpaper";}
            ];
          }
        ];
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
        fuzzelCalc # niri-qalc
        hyprmagnifier # Screen magnifier for Wayland
        playerctl # For play/pause etc... controlling media players that implement MPRIS
        qt5.qtwayland # Needed for QT_QPA_PLATFORM=wayland
        swaybg # Minmal wallpaper setter for Sway
        wallpaperSetter # Specialization-aware wallpaper setting
        windowPicker # niri-pick-window
        wlr-which-key # Chord key menu
        workspaceReorderer # niri-reorder-workspaces
        xwayland-satellite # For apps that need Xwayland
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

      # Auto-column service for vertical monitors
      systemd.user.services.niri-auto-column = lib.mkIf isNumenor {
        Unit = {
          Description = "Auto-consume windows into columns on vertical monitors";
          After = ["niri.service" "graphical-session.target"];
          Wants = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${autoColumn}/bin/niri-auto-column";
          Restart = "on-failure";
          RestartSec = "5";
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };

      programs.wleave.enable = true;

      # Wallpaper, until stylix supports it :)
      home.file.".local/share/wallpapers/gruvbox-light.png".source = ./_wallpapers/gruvbox-light-rainbow.png;
      home.file.".local/share/wallpapers/gruvbox-dark.png".source = ./_wallpapers/gruvbox-dark-rainbow.png;

      xdg.configFile."wlr-which-key/config.yaml".source =
        yaml.generate "wlr-which-key-config" whichKeyConfig;

      # TODO: Activate once the Niri flake supports niri 25.11
      # Per-output layout settings for vertical monitors (raw KDL - not exposed in niri-flake settings)
      # programs.niri.config =
      #   lib.optionalString (leftScreen != null) ''
      #     output "${leftScreen}" {
      #       layout {
      #         default-column-width { proportion 1.0; }
      #       }
      #     }
      #   ''
      #   + lib.optionalString (rightScreen != null) ''
      #     output "${rightScreen}" {
      #       layout {
      #         default-column-width { proportion 1.0; }
      #       }
      #     }
      #   '';
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
          {command = ["ytmdesktop" "--password-store=gnome-libsecret"];}
          # {command = ["seahorse"];} # To unlock keyring
          {command = ["${wallpaperSetter}/bin/niri-set-wallpaper"];} # Set wallpaper
          {command = ["wlsunset-waybar"];}
          {command = ["${openOnWorkspace}/bin/niri-open-on-workspace" "${workspaces."00".name}" "ChatGPT" "zen" "--new-window" "https://chatgpt.com/"];}
          {command = ["${openOnWorkspace}/bin/niri-open-on-workspace" "${workspaces."09".name}" "[Vv]ikunja" "zen" "--new-window" "https://vikunja.hyena-byzantine.ts.net/"];}
        ];

        # Window Rules
        # Find app_id or title with `niri msg windows`
        window-rules = [
          {
            matches = [
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
            ];
            open-on-workspace = " 9";
          }
          {
            matches = [
              {title = ".*[Vv]ikunja.*";}
            ];
            open-on-workspace = " 9";
          }
          {
            matches = [
              {title = ".*ChatGPT.*";}
            ];
            open-on-workspace = " a";
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
          "00" = {
            name = " a";
            open-on-output = rightScreen;
          };
          "01" = {
            name = " 1";
            open-on-output = mainScreen;
          };
          "02" = {
            name = " 2";
            open-on-output = mainScreen;
          };
          "03" = {
            name = " 3";
            open-on-output = rightScreen;
          };
          "04" = {
            name = " 4";
            open-on-output = mainScreen;
          };
          "05" = {
            name = " 5";
            open-on-output = mainScreen;
          };
          "06" = {
            name = " 6";
            open-on-output = mainScreen;
          };
          "07" = {
            name = " 7";
            open-on-output = rightScreen;
          };
          "08" = {
            name = " 8";
            open-on-output = mainScreen;
          };
          "09" = {
            name = " 9";
            open-on-output = leftScreen;
          };
          "10" = {
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
                "a" = ["workspace" "${workspaces."00".name}"];
                "1" = ["workspace" "${workspaces."01".name}"];
                "2" = ["workspace" "${workspaces."02".name}"];
                "3" = ["workspace" "${workspaces."03".name}"];
                "4" = ["workspace" "${workspaces."04".name}"];
                "5" = ["workspace" "${workspaces."05".name}"];
                "6" = ["workspace" "${workspaces."06".name}"];
                "7" = ["workspace" "${workspaces."07".name}"];
                "8" = ["workspace" "${workspaces."08".name}"];
                "9" = ["workspace" "${workspaces."09".name}"];
                "0" = ["workspace" "${workspaces."10".name}"];
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
              "Mod+R".hotkey-overlay.title = "Preset Column Width";
              "Mod+F".action = maximize-column;
              "Mod+Shift+F".action = fullscreen-window;
              "Mod+Ctrl+F".action = expand-column-to-available-width;

              "Print".action.screenshot = [];
              "Print".hotkey-overlay.title = "Screenshot via Niri";
              "Mod+Print".action = spawn "satty-screenshot";
              "Mod+Print".hotkey-overlay.title = "Screenshot via Satty";
              "Mod+Shift+Print".action.screenshot-screen = [];
              "Mod+Shift+Print".hotkey-overlay.title = "Instant Screenshot";

              # Escape hatch for when a buggy app inhibits keyboard shortcuts.
              # allow-inhibiting=false ensures niri always processes this bind.
              "Mod+Shift+Escape".action = toggle-keyboard-shortcuts-inhibit;
              "Mod+Shift+Escape".allow-inhibiting = false;
            }

            {
              # Dynamic Cast ([G]rab Window or Screen)
              "Mod+G".action = set-dynamic-cast-window;
              "Mod+Shift+G".action = set-dynamic-cast-monitor;
              "Mod+Delete".action = clear-dynamic-cast-target;
            }
            {
              # Which Key chord menu
              "Mod+w".action = spawn "wlr-which-key";
              "Mod+w".hotkey-overlay.title = "Which Key Menu";

              # Browser
              "Mod+b".action = spawn-sh (
                if isNvidia
                then "brave --profile-directory='Default' --enable-features=VaapiVideoDecoder,VaapiVideoEncoder --password-store=seahorse"
                else "brave --profile-directory='Default' --password-store=seahorse"
              );
              "Mod+b".hotkey-overlay.hidden = true;

              # Cliphist via fuzzel
              "Mod+p".action = spawn "cliphist-fuzzel-img";
              "Mod+p".hotkey-overlay.hidden = true;

              # Emoji
              "Mod+e".action = spawn "rofimoji";
              "Mod+e".hotkey-overlay.title = "Emoji Picker";
              "Mod+Shift+e".action = spawn ["rofimoji" "--action" "clipboard"];
              "Mod+Shift+e".hotkey-overlay.title = "Emoji to Clipboard";

              # Logout and Power Menu
              "Mod+Pause".action = spawn "wleave";

              # Overview
              "Mod+o".action = toggle-overview;
              "Mod+o".repeat = false;

              # Reorder Workspaces (after moving them around)
              "Mod+Shift+o".action = spawn "${workspaceReorderer}/bin/niri-reorder-workspaces";
              "Mod+Shift+o".hotkey-overlay.title = "Re[o]rder workspaces to maintain logical order";
            }
          ];
      };
    };
}
