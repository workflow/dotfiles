{ config, lib, pkgs, ... }:

let 
  mod = "Mod4";

  # Press $mod+Shift+g to enter the gap mode. Choose o or i for modifying outer/inner gaps.
  # Press one of + / - (in-/decrement for current workspace) or 0 (remove gaps for current workspace).
  # If you also press Shift with these keys, the change will be global for all workspaces.
  mode_gaps = "Gaps: (o) outer, (i) inner";
  mode_gaps_inner = "Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)";
  mode_gaps_outer = "Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)";

  ws1 = "1";
  ws2 = "2";
  ws3 = "3";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6";
  ws7 = "7";
  ws8 = "8: Chat ";
  ws9 = "9: Music ";
  ws10 = "10: Config ";

in {
  xsession.enable = true;
  xsession.scriptPath = ".hm-xsession"; # Ref: https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/8

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      assigns = {
        "${ws8}" = [{ class="^Slack$"; }];
        "${ws9}" = [{ class="^Spotify$"; }];
        "${ws10}" = [{ class="^SpiderOakOne$"; }];
      };

      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
        }
      ];

      # https://github.com/unix121/i3wm-themer/blob/master/themes/001.json
      # <border> <background> <text> <indicator> <child_border>
      colors = rec {
        background = "#1E272B";
        focused = {
          border = "#EAD49B";
          background = "#1E272B";
          text = "#EAD49B";
          indicator = "#9D6A47";
          childBorder = "#9D6A47";
        };
        focusedInactive = {
          border = "#EAD49B";
          background = "#1E272B";
          text = "#EAD49B";
          indicator = "#78824B";
          childBorder = "#78824B";
        };
        placeholder = focusedInactive;
        unfocused = focusedInactive;
        urgent = focusedInactive;
      };

      floating = {
        border = 0;
        criteria = [
          { class = "plasmashell"; }
          { class = "Plasma"; }
          { title = "plasma-desktop"; }
          { title = "win7"; }
          { class = "krunner"; }
          { class = "Kmix"; }
          { class = "Klipper"; }
          { class = "Plasmoidviewer"; }
          { title = "Desktop - Plasma"; }
          { class = "Skype"; }
          { class = "Pavucontrol"; }
        ];
      };

      fonts = ["FontAwesome 10" "Inconsolata 10"];

      gaps = {
        inner = 8;
        smartGaps = true;
        outer = -4;
      }; 

      keybindings = lib.mkOptionDefault {
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

        # lock screen
        "${mod}+Shift+x" = "exec i3lock";

        # toggle tiling / floating
        "${mod}+Shift+space" = "floating toggle";

        # move the currently focused window to the scratchpad
        "${mod}+Shift+minus" = "move scratchpad";

        # Show the next scratchpad window or hide the focused scratchpad window.
        # If there are multiple scratchpad windows, this command cycles through them.
        "${mod}+minus" = "scratchpad show";

        # navigate workspaces next / previous
        "${mod}+Ctrl+semicolon" = "workspace next";
        "${mod}+Ctrl+j" = "workspace prev";

        # Multimedia Key Controls from https://faq.i3wm.org/question/3747/enabling-multimedia-keys/?answer=3759#post-id-3759
        # Pulse Audio controls
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume 1 +5%"; #increase sound volume
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume 1 -5%"; #decrease sound volume
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 1 toggle"; # mute sound

        # Sreen brightness controls
        "XF86MonBrightnessUp" = "exec xbacklight -inc 20"; # increase screen brightness
        "XF86MonBrightnessDown" = "exec xbacklight -dec 20"; # decrease screen brightness

        # Media player controls
        "XF86AudioPlay" = "exec playerctl play";
        "XF86AudioPause" = "exec playerctl pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";

        # Screenshots
        "Print" = "exec --no-startup-id flameshot gui";
        # TODO: Crashes after first screenshot and takes a minute to recover. Is KDE capturing something?
        "Shift+Print" = "exec --no-startup-id flameshot full --clipboard --path ~/Pictures/Flameshot/";

        # Press $mod+Shift+g to enter the gap mode. Choose o or i for modifying outer/inner gaps.
        # Press one of + / - (in-/decrement for current workspace) or 0 (remove gaps for current workspace).
        # If you also press Shift with these keys, the change will be global for all workspaces.
        "${mod}+Shift+g" = "mode \"${mode_gaps}\"";

      };

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

      startup = [
        # https://wiki.archlinux.org/index.php/KDE_Wallet for SSH key passphrases
        { command = "ssh-add -q < /dev/null"; notification = false; }

        # Wallpaper
        { command = "variety"; }

        { command = "spideroak"; }
        { command = "spotify"; }

        # Autoconnect to WIFI after wallet unlock
        { command = "kcmshell5 kcm_networkmanagement"; }
      ];

      terminal = "konsole";

      window = {
        commands = [
          # i3 + plasma5 tipps from https://userbase.kde.org/Tutorials/Using_Other_Window_Managers_with_Plasma
          { command = "kill"; criteria = { title = "Desktop - Plasma"; }; }
          { command = "floating disable"; criteria = { class = "(?i)*nextcloud*"; }; }
          { command = "border none"; criteria = { class = "plasmashell"; window_type = "notification"; }; }
          { command = "move right 700px"; criteria = { class = "plasmashell"; window_type = "notification"; }; }
          { command = "move down 450px"; criteria = { class = "plasmashell"; window_type = "notification"; }; }

          # From https://wiki.archlinux.org/index.php/i3#Default_workspace_for_Spotify
          { command = "move to workspace ${ws9}"; criteria = { class = "Spotify"; }; }
        ];
      };

      workspaceAutoBackAndForth = true;

    };
    extraConfig = ''
      # i3 + plasma5 tipps from https://userbase.kde.org/Tutorials/Using_Other_Window_Managers_with_Plasma
      no_focus [class="plasmashell" window_type="notification"] 
    '';
  };

  # https://github.com/unix121/i3wm-themer/blob/master/themes/001.json
  xresources.properties = {
    "*background" = "#1E272B";
    "*foreground" = "#EAD49B";
    "*cursorColor" = "#EAD49B";

    "*color0" = "#1E272B";
    "*color1" = "#685742";
    "*color2" = "#9D6A47";
    "*color3" = "#B36D43";
    "*color4" = "#78824B";
    "*color5" = "#D99F57";
    "*color6" = "#C9A554";
    "*color7" = "#EAD49B";
    "*color8" = "#666666";
    "*color9" = "#685743";
    "*color10" = "#9D6A47";
    "*color11" = "#B36D43";
    "*color12" = "#78824B";
    "*color13" = "#D99F57";
    "*color14" = "#C9A554";
    "*color15" = "#EAD49B";
    
  };
}
