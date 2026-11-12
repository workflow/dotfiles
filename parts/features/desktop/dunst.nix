{...}: {
  flake.modules.homeManager.dunst = {...}: {
    services.dunst = {
      enable = true;

      settings = {
        global = {
          browser = "brave";
          dmenu = "fuzzel --dmenu";
          follow = "mouse";
          # The default left click only dismisses, so notifications whose
          # click opens a dialog (e.g. Thunderbird's cert exception) were
          # unreachable without knowing about middle click.
          mouse_left_click = "do_action, close_current";
        };
      };
    };
  };
}
