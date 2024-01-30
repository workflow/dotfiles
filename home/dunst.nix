# Themes and many setting looted from: https://github.com/Kthulu120/i3wm-themes/blob/master/Nature/.config/dunst/dunstrc
{ pkgs, ... }:
let
  nixpkgs-unstable = pkgs.unstable;

in
{
  services.dunst = {
    enable = true;

    iconTheme = {
      name = "Pop";
      package = nixpkgs-unstable.pop-icon-theme;
      size = "16x16";
    };

    settings = rec {
      # frame = {
      #   k

      # };

      global = {
        # Alignment of message text.
        # Possible values are "left", "center" and "right".
        alignment = "left";

        # allow_markup = true;

        # The frequency with wich text that is longer than the notification
        # window allows bounces back and forth.
        # This option conflicts with "word_wrap".
        # Set to 0 to disable.
        # bounce_freq = 5;

        # Browser for opening urls in context menu.
        browser = "brave";

        dmenu = "rofi -dmenu -i -p ''";

        # Display notification on focused monitor.  Possible modes are:
        #   mouse: follow mouse pointer
        #   keyboard: follow window with keyboard focus
        #   none: don't follow anything
        #
        # "keyboard" needs a windowmanager that exports the
        # _NET_ACTIVE_WINDOW property.
        # This should be the case for almost all modern windowmanagers.
        #
        # If this option is set to mouse or keyboard, the monitor option
        # will be ignored.
        follow = "keyboard";

        font = "Fira Code 10";

        # The format of the message.  Possible variables are:
        #   %a  appname
        #   %s  summary
        #   %b  body
        #   %i  iconname (including its path)
        #   %I  iconname (without its path)
        #   %p  progress value if set ([  0%] to [100%]) or nothing
        # Markup is allowed
        format = ''%a: %s %p\n%b'';

        frame_color = "#75404b";
        frame_width = 2;


        # The geometry of the window:
        #   [{width}]x{height}[+/-{x}+/-{y}]
        # The geometry of the message window.
        # The height is measured in number of notifications everything else
        # in pixels.  If the width is omitted but the height is given
        # ("-geometry x2"), the message window expands over the whole screen
        # (dmenu-like).  If width is 0, the window expands to the longest
        # message displayed.  A positive x is measured from the left, a
        # negative from the right side of the screen.  Y is measured from
        # the top and down respectevly.
        # The width can be negative.  In this case the actual width is the
        # screen width minus the width defined in within the geometry option.
        # geometry = "0x4-25+25";

        # Maximum amount of notifications kept in history
        history_length = 500;

        # Horizontal padding.
        horizontal_padding = 10;

        # Align icons left/right/off
        icon_position = "left";

        # Don't remove messages, if the user is idle (no mouse or keyboard input)
        # for longer than idle_threshold seconds.
        # Set to 0 to disable.
        # default 120
        idle_threshold = 120;

        # Show how many messages are currently hidden (because of geometry).
        indicate_hidden = true;

        # Ignore newlines '\n' in notifications.
        ignore_newline = false;

        # The height of a single line.  If the height is smaller than the
        # font height, it will get raised to the font height.
        # This adds empty space above and under the text.
        line_height = 0;

        mouse_left_click = "context";
        mouse_right_click = "close_current";
        mouse_middle_click = "close_all";

        # Padding between text and separator.
        padding = 8;

        # Define a color for the separator.
        # possible values are:
        #  * auto: dunst tries to find a color fitting to the background;
        #  * foreground: use the same color as the foreground;
        #  * frame: use the same color as the frame;
        #  * anything else will be interpreted as a X color.
        separator_color = "#454947";

        # Draw a line of "separator_height" pixel height between two
        # notifications.
        # Set to 0 to disable.
        separator_height = 1;

        # Show age of message if message is older than show_age_threshold
        # seconds.
        # Set to -1 to disable.
        show_age_threshold = 60;

        # Display indicators for URLs (U) and actions (A).
        show_indicators = true;

        # Shrink window if it's smaller than the width.  Will be ignored if
        # width is 0.
        shrink = true;

        # Sort messages by urgency.
        sort = true;

        # Print a notification on startup.
        # This is mainly for error detection, since dbus (re-)starts dunst
        # automatically after a crash.
        # startup_notification = true;

        # Should a notification popped up from history be sticky or timeout
        # as if it would normally do.
        sticky_history = true;

        # The transparency of the window.  Range: [0; 100].
        # This option will only work if a compositing windowmanager is
        # present (e.g. xcompmgr, compiz, etc.).
        transparency = 15;

        # Split notifications into multiple lines if they don't fit into
        # geometry.
        word_wrap = true;
      };

      urgency_critical = {
        background = urgency_normal.background;
        foreground = urgency_normal.foreground;

        timeout = 0;
      };

      urgency_low = {
        background = "#162025";
        foreground = "#bfbfbf";

        timeout = 10;
      };

      urgency_normal = urgency_low;

      # Every section that isn't one of the above is interpreted as a rules to
      # override settings for certain messages.
      # Messages can be matched by "appname", "summary", "body", "icon", "category",
      # "msg_urgency" and you can override the "timeout", "urgency", "foreground",
      # "background", "new_icon" and "format".
      # Shell-like globbing will get expanded.
      #
      # SCRIPTING
      # You can specify a script that gets run when the rule matches by
      # setting the "script" option.
      # The script will be called as follows:
      #   script appname summary body icon urgency
      # where urgency can be "LOW", "NORMAL" or "CRITICAL".
      #
      # NOTE: if you don't want a notification to be displayed, set the format
      # to "".
      # NOTE: It might be helpful to run dunst -print in a terminal in order
      # to find fitting options for rules.

      #[espeak]
      #    summary = "*"
      #    script = dunst_espeak.sh

      #[script-test]
      #    summary = "*script*"
      #    script = dunst_test.sh

      #[ignore]
      #    # This notification will not be displayed
      #    summary = "foobar"
      #    format = ""

      #[signed_on]
      #    appname = Pidgin
      #    summary = "*signed on*"
      #    urgency = low
      #
      #[signed_off]
      #    appname = Pidgin
      #    summary = *signed off*
      #    urgency = low
      #
      #[says]
      #    appname = Pidgin
      #    summary = *says*
      #    urgency = critical
      #
      element-desktop = {
        appname = "Element";
        script = "element-desktop";
      };
      #[twitter]
      #    appname = Pidgin
      #    summary = *twitter.com*
      #    urgency = normal
      #
      #[Claws Mail]
      #    appname = claws-mail
      #    category = email.arrived
      #    urgency = normal
      #    background = "#2F899E"
      #    foreground = "#FFA247"
      #
      #[mute.sh]
      #     appname = mute
      #     category = mute.sound
      #     script = mute.sh

    };
  };
}
