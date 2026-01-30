{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.niri = {
    config,
    lib,
    pkgs,
    ...
  }:
    with lib; let
      isNumenor = cfg.dendrix.hostname == "numenor";
      isNvidia = cfg.dendrix.hasNvidia;

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

      wallpaperSetter = pkgs.writeShellApplication {
        name = "niri-set-wallpaper";
        runtimeInputs = [pkgs.swaybg pkgs.procps];
        text = builtins.readFile ./_scripts/niri-set-wallpaper.sh;
      };

      windowPicker = pkgs.writeShellApplication {
        name = "niri-pick-window";
        runtimeInputs = [pkgs.niri pkgs.unstable.fuzzel pkgs.jq];
        text = builtins.readFile ./_scripts/niri-pick-window.sh;
      };

      fuzzelCalc = pkgs.writeShellApplication {
        name = "niri-qalc";
        runtimeInputs = [pkgs.unstable.fuzzel pkgs.libqalculate pkgs.wl-clipboard pkgs.libnotify];
        text = builtins.readFile ./_scripts/niri-qalc.sh;
      };

      workspaceReorderer = pkgs.writeShellApplication {
        name = "niri-reorder-workspaces";
        runtimeInputs = [pkgs.niri pkgs.jq];
        text = builtins.readFile ./_scripts/niri-reorder-workspaces.sh;
      };

      autoColumn = pkgs.writeShellApplication {
        name = "niri-auto-column";
        runtimeInputs = [pkgs.niri pkgs.jq pkgs.coreutils];
        text = builtins.readFile ./_scripts/niri-auto-column.sh;
      };

      openOnWorkspace = pkgs.writeShellApplication {
        name = "niri-open-on-workspace";
        runtimeInputs = [pkgs.niri pkgs.jq];
        text = builtins.readFile ./_scripts/niri-open-on-workspace.sh;
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
        brightnessctl
        fuzzelCalc
        hyprmagnifier
        playerctl
        qt5.qtwayland
        swaybg
        wallpaperSetter
        windowPicker
        workspaceReorderer
        xwayland-satellite
      ];

      programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
        settings = {
          debug = false;
          show-failed-attempts = true;
          ignore-empty-password = true;
          screenshots = true;
          effect-pixelate = 10;
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

      systemd.user.services.swayidle = {
        Unit = {
          After = ["niri.service" "graphical-session.target"];
          Wants = ["graphical-session.target"];
          ConditionEnvironment = lib.mkForce [];
        };
        Service = {
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
          Restart = lib.mkForce "on-failure";
          RestartSec = "5";
        };
      };

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
        Install.WantedBy = ["graphical-session.target"];
      };

      programs.wleave.enable = true;

      home.file.".local/share/wallpapers/gruvbox-light.png".source = ./_wallpapers/gruvbox-light-rainbow.png;
      home.file.".local/share/wallpapers/gruvbox-dark.png".source = ./_wallpapers/gruvbox-dark-rainbow.png;

      programs.niri.settings = rec {
        environment.NIXOS_OZONE_WL = "1";

        input = {
          keyboard.xkb = {
            layout = "us,de,ua,pt";
            options = "eurosign:e,terminate:ctrl_alt_bksp";
          };
          touchpad = {
            dwt = true;
            disabled-on-external-mouse = false;
            natural-scroll = false;
            tap = true;
            tap-button-map = "left-right-middle";
          };
          focus-follows-mouse.enable = true;
        };

        cursor = {
          hide-after-inactive-ms = 3000;
          hide-when-typing = true;
        };

        spawn-at-startup = [
          {command = ["${pkgs.bash}/bin/bash" "-c" "sleep 10 && systemctl --user restart xdg-desktop-portal"];}
          {command = ["systemctl" "--user" "restart" "kanshi"];}
          {command = ["systemctl" "--user" "restart" "app-blueman@autostart"];}
          {command = ["systemctl" "--user" "start" "gnome-keyring-ssh"];}
          {command = ["obsidian"];}
          {command = ["ytmdesktop" "--password-store=gnome-libsecret"];}
          {command = ["${wallpaperSetter}/bin/niri-set-wallpaper"];}
          {command = ["wlsunset-waybar"];}
          {command = ["${openOnWorkspace}/bin/niri-open-on-workspace" "${workspaces."00".name}" "ChatGPT" "zen" "--new-window" "https://chatgpt.com/"];}
          {command = ["${openOnWorkspace}/bin/niri-open-on-workspace" "${workspaces."09".name}" "[Vv]ikunja" "zen" "--new-window" "https://vikunja.hyena-byzantine.ts.net/"];}
        ];

        window-rules = [
          {
            matches = [{app-id = "^obsidian$";}];
            open-on-workspace = " 7";
          }
          {
            matches = [
              {app-id = "^signal$";}
              {app-id = "^teams-for-linux$";}
              {app-id = "^org.telegram.desktop$";}
            ];
            open-on-workspace = " 8";
          }
          {
            matches = [{app-id = "^YouTube Music Desktop App$";}];
            open-on-workspace = " 9";
          }
          {
            matches = [{title = ".*[Vv]ikunja.*";}];
            open-on-workspace = " 9";
          }
          {
            matches = [{title = ".*ChatGPT.*";}];
            open-on-workspace = " a";
          }
          {
            matches = [
              {title = ".*Pavucontrol.*";}
              {title = ".*zoom.*";}
            ];
            open-floating = true;
          }
          {
            matches = [
              {app-id = "^Bitwarden$";}
              {app-id = "^com.obsproject.Studio$";}
            ];
            block-out-from = "screen-capture";
          }
          {
            matches = [{is-window-cast-target = true;}];
            border = {
              active.color = "#f38ba8";
              inactive.color = "#7d0d2d";
            };
            shadow.color = "#7d0d2d70";
            tab-indicator = {
              active.color = "#f38ba8";
              inactive.color = "#7d0d2d";
            };
          }
        ];

        workspaces = {
          "00" = {
            name = " a";
            open-on-output = rightScreen;
          };
          "01" = {
            name = " 1";
            open-on-output = leftScreen;
          };
          "02" = {
            name = " 2";
            open-on-output = mainScreen;
          };
          "03" = {
            name = " 3";
            open-on-output = rightScreen;
          };
          "04" = {
            name = " 4";
            open-on-output = mainScreen;
          };
          "05" = {
            name = " 5";
            open-on-output = mainScreen;
          };
          "06" = {
            name = " 6";
            open-on-output = mainScreen;
          };
          "07" = {
            name = " 7";
            open-on-output = rightScreen;
          };
          "08" = {
            name = " 8";
            open-on-output = mainScreen;
          };
          "09" = {
            name = " 9";
            open-on-output = leftScreen;
          };
          "10" = {
            name = " 10";
            open-on-output = mainScreen;
          };
        };

        layout = {
          border = {
            enable = true;
            width = 2;
          };
          default-column-width.proportion = 1. / 2.;
          gaps = 4;
          preset-column-widths = [
            {proportion = 1. / 2.;}
            {proportion = 1. / 3.;}
            {proportion = 2. / 3.;}
          ];
          shadow.enable = true;
        };

        prefer-no-csd = true;
        animations.workspace-switch.enable = false;
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
              "Mod+z".action = spawn "hyprmagnifier";
              "Mod+z".hotkey-overlay.title = "Screen magnifier";
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
              "Print".action.screenshot = [];
              "Print".hotkey-overlay.title = "Screenshot via Niri";
              "Mod+Print".action = spawn "satty-screenshot";
              "Mod+Print".hotkey-overlay.title = "Screenshot via Satty";
              "Mod+Shift+Print".action.screenshot-screen = [];
              "Mod+Shift+Print".hotkey-overlay.title = "Instant Screenshot";
              "Mod+Shift+Escape".action = toggle-keyboard-shortcuts-inhibit;
              "Mod+Shift+Escape".allow-inhibiting = false;
              "Ctrl+Alt+Delete".action = quit;
            }
            {
              "Mod+G".action = set-dynamic-cast-window;
              "Mod+Shift+G".action = set-dynamic-cast-monitor;
              "Mod+Delete".action = clear-dynamic-cast-target;
              "Mod+Tab".action = focus-window-down-or-column-right;
              "Mod+Shift+Tab".action = focus-window-up-or-column-left;
            }
            {
              "Mod+b".action = spawn-sh (
                if isNvidia
                then "brave --profile-directory='Default' --enable-features=VaapiVideoDecoder,VaapiVideoEncoder --password-store=seahorse"
                else "brave --profile-directory='Default' --password-store=seahorse"
              );
              "Mod+b".hotkey-overlay.hidden = true;
              "Mod+Shift+b".action = spawn "zen";
              "Mod+Shift+b".hotkey-overlay.hidden = true;
              "Mod+h".action = spawn-sh (
                if isNvidia
                then "brave --profile-directory='Profile 1' --enable-features=VaapiVideoDecoder,VaapiVideoEncoder --password-store=seahorse"
                else "brave --profile-directory='Profile 1' --password-store=seahorse"
              );
              "Mod+h".hotkey-overlay.hidden = true;
              "Mod+p".action = spawn "cliphist-fuzzel-img";
              "Mod+p".hotkey-overlay.hidden = true;
              "Mod+Shift+p".action = spawn-sh "cliphist list | fuzzel --dmenu | cliphist delete";
              "Mod+Shift+p".hotkey-overlay.hidden = true;
              "Mod+n".action = spawn-sh "alacritty -e fish -ic lf";
              "Mod+n".hotkey-overlay.hidden = true;
              "Mod+m".action = spawn "${fuzzelCalc}/bin/niri-qalc";
              "Mod+m".hotkey-overlay.title = "Calcu[M]athalor via qalculate";
              "Mod+Pause".action = spawn "wleave";
              "Mod+w".action = spawn "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu";
              "Mod+w".hotkey-overlay.hidden = true;
              "Mod+o".action = toggle-overview;
              "Mod+o".repeat = false;
              "Mod+Shift+o".action = spawn "${workspaceReorderer}/bin/niri-reorder-workspaces";
              "Mod+Shift+o".hotkey-overlay.title = "Re[o]rder workspaces to maintain logical order";
              "Mod+e".action = spawn "rofimoji";
              "Mod+e".hotkey-overlay.hidden = true;
              "Mod+Shift+e".action = spawn ["rofimoji" "--action" "clipboard"];
              "Mod+Shift+e".hotkey-overlay.hidden = true;
              "Mod+s".action = spawn "sound-switcher";
              "Mod+s".hotkey-overlay.hidden = true;
            }
            {
              "Alt+F1".action = spawn "obs-main-scene";
              "Alt+F1".hotkey-overlay.title = "OBS: Switch to Main Scene";
              "Alt+F2".action = spawn "obs-screensharing";
              "Alt+F2".hotkey-overlay.title = "OBS: Switch to Screensharing";
              "Alt+F3".action = spawn "obs-catcam-toggle";
              "Alt+F3".hotkey-overlay.title = "OBS: Toggle Catcam";
              "Alt+F4".action = spawn "obs-recording-toggle";
              "Alt+F4".hotkey-overlay.title = "OBS: Start/Stop Recording";
              "Alt+F5".action = spawn "obs-recording-pause";
              "Alt+F5".hotkey-overlay.title = "OBS: Pause/Unpause Recording";
              "Alt+F6".action = spawn "obs-webcam-toggle";
              "Alt+F6".hotkey-overlay.title = "OBS: Toggle Webcam";
            }
          ];
      };
    };
}
