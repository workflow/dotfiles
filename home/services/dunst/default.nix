{...}: {
  services.dunst = {
    enable = true;

    settings = {
      global = {
        browser = "brave";
        dmenu = "rofi -dmenu -i -p ''";
      };
    };
  };
}
