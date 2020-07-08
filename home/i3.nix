{ config, lib, pkgs, ... }:

let 
  mod = "Mod4";

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
        "${ws8}" = [];
        "${ws9}" = [{ class="^Spotify$"; }];
        "${ws10}" = [{ class="^SpiderOakOne$"; }];
      };

      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
        }
      ];

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
        ];
      };

      fonts = ["FontAwesome 10" "monospace 10"];

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

      };

      modifier = mod;

      startup = [
        # https://wiki.archlinux.org/index.php/KDE_Wallet for SSH key passphrases
        { command = "ssh-add -q < /dev/null"; notification = false; }

        # Wallpaper
        { command = "variety"; always = true; }

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
}
