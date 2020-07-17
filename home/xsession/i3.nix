{ lib, pkgs, ...}:

let 
  # https://github.com/unix121/i3wm-themer/blob/master/themes/001.json
  color_bg = "#1E272B";
  color_txt = "#EAD49B";

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
  ws8 = "8: ";
  ws9 = "9: ";
  ws10 = "10: ";

in {
  enable = true;

  config = {
    assigns = {
      "${ws8}" = [
        { class="^Slack$"; }
        { class="^Signal$"; }
      ];
      "${ws9}" = [{ class="^Spotify$"; }];
      "${ws10}" = [{ class="^SpiderOakONE$"; }];
    };

    bars = [
      {
        colors = rec {
          activeWorkspace =  {
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
        command = "${pkgs.i3-gaps}/bin/i3bar";
        fonts = [ "FontAwesome5 8" "Inconsolata 8" ];
        position = "bottom";
        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
      }
    ];

    # https://github.com/unix121/i3wm-themer/blob/master/themes/001.json
    # <border> <background> <text> <indicator> <child_border>
    colors = rec {
      background = color_bg;
      focused = {
        border = color_txt;
        background = color_bg;
        text = color_txt;
        indicator = "#9D6A47";
        childBorder = "#9D6A47";
      };
      focusedInactive = {
        border = color_txt;
        background = color_bg;
        text = color_txt;
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
        { class = "Signal"; }
      ];
    };

    fonts = ["FontAwesome 9" "Inconsolata 9"];

    gaps = {
      inner = 4;

      smartBorders = "on";
      smartGaps = true;

      outer = -2;
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

      # Move container to workspace
      "${mod}+Shift+1" = "move container to workspace ${ws1}";
      "${mod}+Shift+2" = "move container to workspace ${ws2}";
      "${mod}+Shift+3" = "move container to workspace ${ws3}";
      "${mod}+Shift+4" = "move container to workspace ${ws4}";
      "${mod}+Shift+5" = "move container to workspace ${ws5}";
      "${mod}+Shift+6" = "move container to workspace ${ws6}";
      "${mod}+Shift+7" = "move container to workspace ${ws7}";
      "${mod}+Shift+8" = "move container to workspace ${ws8}";
      "${mod}+Shift+9" = "move container to workspace ${ws9}";
      "${mod}+Shift+0" = "move container to workspace ${ws10}";

      # Move container to workspace and focus
      "${mod}+Control+1" = "move container to workspace ${ws1}; workspace ${ws1}";
      "${mod}+Control+2" = "move container to workspace ${ws2}; workspace ${ws2}";
      "${mod}+Control+3" = "move container to workspace ${ws3}; workspace ${ws3}";
      "${mod}+Control+4" = "move container to workspace ${ws4}; workspace ${ws4}";
      "${mod}+Control+5" = "move container to workspace ${ws5}; workspace ${ws5}";
      "${mod}+Control+6" = "move container to workspace ${ws6}; workspace ${ws6}";
      "${mod}+Control+7" = "move container to workspace ${ws7}; workspace ${ws7}";
      "${mod}+Control+8" = "move container to workspace ${ws8}; workspace ${ws8}";
      "${mod}+Control+9" = "move container to workspace ${ws9}; workspace ${ws9}";
      "${mod}+Control+0" = "move container to workspace ${ws10}; workspace ${ws10}";

      # Move workspace between screens
      "${mod}+Control+j" = "move workspace to output eDP-1";
      "${mod}+Control+semicolon" = "move workspace to output DP-2-1";

      # lock screen
      "${mod}+Shift+x" = "exec i3lock-pixeled";

      # toggle tiling / floating
      "${mod}+Shift+space" = "floating toggle";

      # move the currently focused window to the scratchpad
      "${mod}+Shift+minus" = "move scratchpad";

      # Show the next scratchpad window or hide the focused scratchpad window.
      # If there are multiple scratchpad windows, this command cycles through them.
      "${mod}+minus" = "scratchpad show";

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

    menu = "rofi -show run";

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
      # Detect and apply screen layout
      { command = "autorandr --change"; notification = false; }

      # https://wiki.archlinux.org/index.php/KDE_Wallet for SSH key passphrases
      { command = "ssh-add -q < /dev/null"; notification = false; }

      # Configure Mega backups
      { command = "configure-mega-backup"; notification = false; }

      # Start duplicati server (not a service yet)
      { command = "duplicati-server"; notification = false; }

      # Wallpaper
      { command = "variety"; notification = false; }

      { command = "spotify"; notification = false; }

      # Autoconnect to WIFI after wallet unlock
      { command = "kcmshell5 kcm_networkmanagement"; }

      # Syncthing Tray
      # TODO: Can be removed once https://github.com/rycee/home-manager/pull/1257 is merged
      { command = "sleep 10; syncthingtray"; notification = false; }
    ];

    terminal = "urxvt -e fish";

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
    default_border pixel 1

    # i3 + plasma5 tipps from https://userbase.kde.org/Tutorials/Using_Other_Window_Managers_with_Plasma
    no_focus [class="plasmashell" window_type="notification"] 
  '';
}
