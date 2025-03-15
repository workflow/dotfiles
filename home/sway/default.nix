{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  # https://github.com/unix121/i3wm-themer/blob/master/themes/001.json
  color_bg = "#1E272B";
  color_txt = "#EAD49B";

  networkManager = "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu";

  isBoar = osConfig.networking.hostName == "boar";
  isFlexbox = osConfig.networking.hostName == "flexbox";

  locker = "${pkgs.i3lock-pixeled}/bin/i3lock-pixeled";
  screenShutter = "xset dpms force off";
  suspender = "systemctl suspend-then-hibernate";

  mod = "Mod4";

  # Press $mod+Shift+g to enter the gap mode. Choose o or i for modifying outer/inner gaps.
  # Press one of + / - (in-/decrement for current workspace) or 0 (remove gaps for current workspace).
  # If you also press Shift with these keys, the change will be global for all workspaces.
  mode_gaps = "Gaps: (o) outer, (i) inner";
  mode_gaps_inner = "Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)";
  mode_gaps_outer = "Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)";

  mode_system = "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown";

  ws1 = "1";
  ws2 = "2";
  ws3 = "3";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6";
  ws7 = "7";
  ws8 = "8: ";
  ws9 = "9: ";
  ws10 = "10: ";

  ws11 = "11";
  ws12 = "12";
  ws13 = "13";
  ws14 = "14";
  ws15 = "15";
  ws16 = "16";
  ws17 = "17";
  ws18 = "18";
  ws19 = "19";
  ws20 = "20";

  wsc = "c";
in {
  wayland.windowManager.sway = {
    enable = true;

    config = {
      assigns = {
        "${ws8}" = [
          {class = "^Slack$";}
          {class = "^Signal$";}
          {class = "^TelegramDesktop$";}
          {class = "^Skype$";}
          {class = "^Discord$";}
          {class = "^Element$";}
        ];
        "${ws9}" = [
          {class = "^YouTube Music$";}
          {class = "^Todoist$";}
        ];
        "${ws19}" = [
          {class = "^obsidian$";}
        ];
      };

      bars =
        [
          {
            colors = rec {
              activeWorkspace = {
                background = color_bg;
                border = color_txt;
                text = color_txt;
              };
              background = "#282828"; # To match i3status_rust theme
              focusedWorkspace = activeWorkspace;
              inactiveWorkspace = {
                background = "#282828"; # To match i3status_rust theme
                border = "#282828"; # To match i3status_rust theme
                text = "#ebdbb2"; # To match i3status_rust theme
              };
            };
            extraConfig = let
              primaryOutput =
                if isFlexbox
                then "eDP-1"
                else "DP-0-0";
            in ''
              output ${primaryOutput}
            '';
            fonts = {
              names = ["Fira Code" "Font Awesome 6 Free"];
              size = 9.0;
            };
            position = "bottom";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          }
        ]
        ++ lib.lists.optionals isBoar [
          {
            colors = rec {
              activeWorkspace = {
                background = color_bg;
                border = color_txt;
                text = color_txt;
              };
              background = "#282828"; # To match i3status_rust theme
              focusedWorkspace = activeWorkspace;
              inactiveWorkspace = {
                background = "#282828"; # To match i3status_rust theme
                border = "#282828"; # To match i3status_rust theme
                text = "#ebdbb2"; # To match i3status_rust theme
              };
            };
            extraConfig = ''
              output HDMI-A-1
            '';
            fonts = {
              names = ["Fira Code" "Font Awesome 6 Free"];
              size = 9.0;
            };
            position = "bottom";
            trayOutput = null;
          }
          {
            colors = rec {
              activeWorkspace = {
                background = color_bg;
                border = color_txt;
                text = color_txt;
              };
              background = "#282828"; # To match i3status_rust theme
              focusedWorkspace = activeWorkspace;
              inactiveWorkspace = {
                background = "#282828"; # To match i3status_rust theme
                border = "#282828"; # To match i3status_rust theme
                text = "#ebdbb2"; # To match i3status_rust theme
              };
            };
            extraConfig = ''
              output HDMI-A-0
            '';
            fonts = {
              names = ["Fira Code" "Font Awesome 6 Free"];
              size = 9.0;
            };
            position = "bottom";
            trayOutput = null;
          }
        ];

      floating = {
        border = 0;
        criteria = [
          {class = "Pavucontrol";}
          {class = "zoom";}
        ];
      };

      gaps = {
        inner = 4;

        smartBorders = "on";
        smartGaps = true;

        outer = -2;
      };

      input = {
        "*" = {
          xkb_layout = "us,de,ua,pt";
          xkb_options = "grp:ctrls_toggle,eurosign:e,caps:escape_shifted_capslock,terminate:ctrl_alt_bksp";
        };
      };

      keybindings = lib.mkOptionDefault ({
          # Split
          "${mod}+v" = "split v";
          "${mod}+s" = "split h";

          # Focus
          "${mod}+j" = "focus left";
          "${mod}+k" = "focus down";
          "${mod}+l" = "focus up";
          "${mod}+semicolon" = "focus right";

          # Move
          "${mod}+Shift+j" = "move left";
          "${mod}+Shift+k" = "move down";
          "${mod}+Shift+l" = "move up";
          "${mod}+Shift+semicolon" = "move right";

          # Move to workspace
          "${mod}+1" = "workspace ${ws1}";
          "${mod}+2" = "workspace ${ws2}";
          "${mod}+3" = "workspace ${ws3}";
          "${mod}+4" = "workspace ${ws4}";
          "${mod}+5" = "workspace ${ws5}";
          "${mod}+6" = "workspace ${ws6}";
          "${mod}+7" = "workspace ${ws7}";
          "${mod}+8" = "workspace ${ws8}";
          "${mod}+9" = "workspace ${ws9}";
          "${mod}+0" = "workspace ${ws10}";
          "${mod}+Mod1+1" = "workspace ${ws11}";
          "${mod}+Mod1+2" = "workspace ${ws12}";
          "${mod}+Mod1+3" = "workspace ${ws13}";
          "${mod}+Mod1+4" = "workspace ${ws14}";
          "${mod}+Mod1+5" = "workspace ${ws15}";
          "${mod}+Mod1+6" = "workspace ${ws16}";
          "${mod}+Mod1+7" = "workspace ${ws17}";
          "${mod}+Mod1+8" = "workspace ${ws18}";
          "${mod}+Mod1+9" = "workspace ${ws19}";
          "${mod}+Mod1+0" = "workspace ${ws20}";
          "${mod}+c" = "workspace ${wsc}";

          # Move container to workspace and focus
          "${mod}+Shift+1" = "move container to workspace ${ws1}; workspace ${ws1}";
          "${mod}+Shift+2" = "move container to workspace ${ws2}; workspace ${ws2}";
          "${mod}+Shift+3" = "move container to workspace ${ws3}; workspace ${ws3}";
          "${mod}+Shift+4" = "move container to workspace ${ws4}; workspace ${ws4}";
          "${mod}+Shift+5" = "move container to workspace ${ws5}; workspace ${ws5}";
          "${mod}+Shift+6" = "move container to workspace ${ws6}; workspace ${ws6}";
          "${mod}+Shift+7" = "move container to workspace ${ws7}; workspace ${ws7}";
          "${mod}+Shift+8" = "move container to workspace ${ws8}; workspace ${ws8}";
          "${mod}+Shift+9" = "move container to workspace ${ws9}; workspace ${ws9}";
          "${mod}+Shift+0" = "move container to workspace ${ws10}; workspace ${ws10}";
          "${mod}+Shift+Mod1+1" = "move container to workspace ${ws11}; workspace ${ws11}";
          "${mod}+Shift+Mod1+2" = "move container to workspace ${ws12}; workspace ${ws12}";
          "${mod}+Shift+Mod1+3" = "move container to workspace ${ws13}; workspace ${ws13}";
          "${mod}+Shift+Mod1+4" = "move container to workspace ${ws14}; workspace ${ws14}";
          "${mod}+Shift+Mod1+5" = "move container to workspace ${ws15}; workspace ${ws15}";
          "${mod}+Shift+Mod1+6" = "move container to workspace ${ws16}; workspace ${ws16}";
          "${mod}+Shift+Mod1+7" = "move container to workspace ${ws17}; workspace ${ws17}";
          "${mod}+Shift+Mod1+8" = "move container to workspace ${ws18}; workspace ${ws18}";
          "${mod}+Shift+Mod1+9" = "move container to workspace ${ws19}; workspace ${ws19}";
          "${mod}+Shift+Mod1+0" = "move container to workspace ${ws20}; workspace ${ws20}";
          "${mod}+Shift+c" = "move container to workspace ${wsc}; workspace ${wsc}";

          # Move workspace between screens
          "${mod}+Control+j" = "move workspace to output left";
          "${mod}+Control+semicolon" = "move workspace to output right";

          # lock screen
          "${mod}+Shift+x" = "exec xidlehook-client --socket /tmp/xidlehook.sock control --action trigger --timer 0";

          # Layout
          # toggle tiling / floating
          "${mod}+Shift+space" = "floating toggle";
          # Toggle split
          "${mod}+Shift+e" = "layout toggle split";
          # Stacking
          "${mod}+Shift+s" = "layout stacking";
          # Tabbed
          "${mod}+Shift+w" = "layout tabbed";

          # move the currently focused window to the scratchpad
          "${mod}+Shift+minus" = "move scratchpad";

          # Show the next scratchpad window or hide the focused scratchpad window.
          # If there are multiple scratchpad windows, this command cycles through them.
          "${mod}+minus" = "scratchpad show";

          # Rofi Run Mode (nvidia-offload)
          "${mod}+o" = "exec rofi -modi drun#run#combi#calc -show run -show-icons -run-shell-command '{terminal} -e fish -ic \"{cmd} && read\"' -matching fuzzy";

          # Cliphist via rofi
          "${mod}+p" = "exec cliphist list | rofi -dmenu | cliphist decode | wl-copy";
          # Single item clearing
          "${mod}+Shift+p" = "exec cliphist list | rofi -dmenu | cliphist delete";

          # Multimedia Key Controls from https://faq.i3wm.org/question/3747/enabling-multimedia-keys/?answer=3759#post-id-3759
          # Pulse Audio controls
          "XF86AudioRaiseVolume" = "exec  wpctl set-volume @DEFAULT_SINK@ 5%+"; #increase sound volume
          "XF86AudioLowerVolume" = "exec  wpctl set-volume @DEFAULT_SINK@ 5%-"; #decrease sound volume
          "XF86AudioMute" = "exec  wpctl set-mute @DEFAULT_SINK@ toggle"; # mute sound

          # Screen brightness controls
          "XF86MonBrightnessUp" = "exec brightnessctl set +50"; # increase screen brightness
          "XF86MonBrightnessDown" = "exec brightnessctl set 50-"; # decrease screen brightness

          # Media player controls
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";

          # Screenshots
          "Print" = "exec QT_SCALE_FACTOR=0.5 flameshot gui";
          "Shift+Print" = "exec QT_SCALE_FACTOR=0.5 flameshot full --clipboard --path ~/Pictures/Flameshot/";

          # Press $mod+Shift+g to enter the gap mode. Choose o or i for modifying outer/inner gaps.
          # Press one of + / - (in-/decrement for current workspace) or 0 (remove gaps for current workspace).
          # If you also press Shift with these keys, the change will be global for all workspaces.
          "${mod}+Shift+g" = "mode \"${mode_gaps}\"";

          # Rofi window switcher
          "${mod}+Shift+d" = ''exec "rofi -show window -matching fuzzy"'';

          # Dunst shortcuts via dunstctl
          "${mod}+Ctrl+space" = "exec  dunstctl close-all";
          "${mod}+Ctrl+c" = "exec  dunstctl context";
          "${mod}+Ctrl+h" = "exec  dunstctl history-pop";

          # Launch Browser
          "${mod}+b" = "exec \"brave --profile-directory='Default' --enable-features='VaapiVideoDecoder,VaapiVideoEncoder' --enable-raw-draw --password-store=seahorse\"";
          "${mod}+h" = "exec \"brave --profile-directory='Profile 1' --enable-features='VaapiVideoDecoder,VaapiVideoEncoder' --enable-raw-draw --password-store=seahorse\"";

          # File Manager ("navigate")
          "${mod}+n" = "exec \"alacritty -e fish -ic lf\"";

          # System Mode
          "${mod}+Pause" = "mode \"${mode_system}\"";

          # Invert Colors
          "${mod}+i" = "exec  ~/nixos-config/home/xsession/per_window_color_invert.sh";
          "${mod}+Shift+i" = "exec  xrandr-invert-colors";

          # Net[w]orkmanager
          "${mod}+w" = "exec ${networkManager}";

          # Rofimoji
          "${mod}+e" = "exec rofimoji";

          # Reload Sway Config
          "${mod}+Shift+r" = "reload";
        }
        // lib.optionalAttrs true {
          # Sound Switcher
          "${mod}+m" = "exec sound-switcher-boar";
        }
        // lib.optionalAttrs isFlexbox {
          # Sound Switcher
          "${mod}+m" = "exec sound-switcher-flexbox";
        });

      menu = "rofi -modi drun#run#combi#calc -show drun -show-icons -run-shell-command '{terminal} -e fish -ic \"{cmd} && read\"' -matching fuzzy";

      # Press $mod+Shift+g to enter the gap mode. Choose o or i for modifying outer/inner gaps.
      # Press one of + / - (in-/decrement for current workspace) or 0 (remove gaps for current workspace).
      # If you also press Shift with these keys, the change will be global for all workspaces.
      modes = lib.mkOptionDefault {
        "${mode_gaps}" = {
          i = "mode \"${mode_gaps_inner}\"";
          o = "mode \"${mode_gaps_outer}\"";
          Return = "mode default";
          Escape = "mode default";
        };
        "${mode_gaps_inner}" = {
          plus = "gaps inner current plus 5";
          minus = "gaps inner current minus 5";
          "0" = "gaps inner current set 0";

          "Shift+plus" = "gaps inner all plus 5";
          "Shift+minus" = "gaps inner all minus 5";
          "Shift+0" = "gaps inner all set 0";

          Return = "mode default";
          Escape = "mode default";
        };
        "${mode_gaps_outer}" = {
          plus = "gaps outer current plus 5";
          minus = "gaps outer current minus 5";
          "0" = "gaps outer current set 0";

          "Shift+plus" = "gaps outer all plus 5";
          "Shift+minus" = "gaps outer all minus 5";
          "Shift+0" = "gaps outer all set 0";

          Return = "mode default";
          Escape = "mode default";
        };
      };

      modifier = mod;

      seat = {
        "*" = {
          hide_cursor = "3000"; # Similar to unlutter on X, hide mouse cursor after 3 seconds of inactivity
        };
      };

      startup =
        [
          {command = "youtube-music";}
          {command = "todoist";}

          # Auto lock screen on screen off, suspend, etc...
          {command = ''xss-lock -- "${locker}"'';}

          # Autotiling
          {
            command = "autotiling &";
            always = true;
          }

          # Disconnect tailscale
          {command = "sudo tailscale down";}

          # Variety
          {command = "/bin/bash -c 'sleep 20 && ${pkgs.variety}/bin/variety --profile /home/farlion/.config/variety/";}

          # Seahorse for keyring unlocking (still haven't manage to pop that GUI unlock prompt open programatically...)
          {command = "seahorse";}
        ]
        # ++ lib.lists.optionals isFlexbox
        # [
        #   { command = ''xidlehook --socket /tmp/xidlehook.sock --detect-sleep --not-when-audio --not-when-fullscreen --timer 360 "${screenShutter}" "" --timer 1800 "${suspender}" ""''; }
        # ]
        ++ lib.lists.optionals isBoar
        [
          {command = ''xidlehook --socket /tmp/xidlehook.sock --not-when-audio --not-when-fullscreen --timer 360 "${screenShutter}" ""'';}
        ];

      terminal = "alacritty";

      workspaceAutoBackAndForth = false;
    };

    systemd = {
      enable = true; # Enables sway-session.target, see home-manager manual
    };

    extraConfig = ''
      default_border pixel 1
      for_window [class="^.*"] border pixel 1

      bindsym ${mod}+Ctrl+x --release exec  xkill

      # System mode. Can't be put into config.modes because of chained commands.
      mode "${mode_system}" {
        bindsym l exec  ${screenShutter}, mode "default"
        bindsym e exec  swaymsg exit, mode "default"
        bindsym s exec  systemctl suspend, mode "default"
        bindsym h exec  systemctl hibernate, mode "default"
        bindsym r exec  systemctl reboot, mode "default"
        bindsym Shift+s exec  systemctl poweroff -i, mode "default"

        # back to normal: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
      }

      # Hide cursor when typing, cannot be set via explciti home-manager "seat" setting since the type system conflicts
      seat "*" {
        hide_cursor when-typing enable
      }
    '';

    extraOptions = [
      "--unsupported-gpu"
    ];
  };
}
