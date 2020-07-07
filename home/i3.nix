{ config, lib, pkgs, ... }:

let 
  mod = "Mod4";
in {
  xsession.scriptPath = ".hm-xsession"; # Ref: https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/8

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
        }
      ];

      fonts = ["pango:monospace 8" "FontAwesome 6"];

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

        # start a terminal
        "${mod}+Return" = "exec konsole";

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

    };
    extraConfig = ''
      # Define names for default workspaces for which we configure key bindings later on.
      # We use variables to avoid repeating the names in multiple places.
      set $ws1 "1"
      set $ws2 "2"
      set $ws3 "3"
      set $ws4 "4"
      set $ws5 "5"
      set $ws6 "6"
      set $ws7 "7"
      set $ws8 "8: Chat "
      set $ws9 "9: Music "
      set $ws10 "10: Config "

      # i3 + plasma5 tipps from https://userbase.kde.org/Tutorials/Using_Other_Window_Managers_with_Plasma
      for_window [title="Desktop — Plasma"] kill; floating enable; border none
      for_window [class="plasmashell"] floating enable;
      for_window [class="Plasma"] floating enable; border none
      for_window [title="plasma-desktop"] floating enable; border none
      for_window [title="win7"] floating enable; border none
      for_window [class="krunner"] floating enable; border none
      for_window [class="Kmix"] floating enable; border none
      for_window [class="Klipper"] floating enable; border none
      for_window [class="Plasmoidviewer"] floating enable; border none
      for_window [class="(?i)*nextcloud*"] floating disable
      for_window [class="plasmashell" window_type="notification"] floating enable, border none, move right 700px, move down 450px
      no_focus [class="plasmashell" window_type="notification"] 

      #
      # Autostart stuff
      #
      exec spotify 
      # From https://wiki.archlinux.org/index.php/i3#Default_workspace_for_Spotify
      for_window [class="Spotify"] move to workspace $ws9

      exec variety

      exec spideroak
      assign [class="SpiderOakOne"] $ws10

      # https://wiki.archlinux.org/index.php/KDE_Wallet for SSH key passphrases
      exec --no-startup-id ssh-add -q < /dev/null
      # Autoconnect to WIFI after wallet unlock
      exec --no-startup-id kcmshell5 kcm_networkmanagement
    '';
  };
}
