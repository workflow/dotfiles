{...}: {
  services.dunst = {
    enable = true;

    settings = {
      global = {
        browser = "brave";
        dmenu = "rofi -dmenu -i -p ''";
      };

      ignore_flameshot_warning = {
        appname = "flameshot";
        body = "ngrim's screenshot component is implemented based on wlroots, it may not be used in GNOME or similar desktop environments";
        skip_display = true;
      };
    };
  };
}
