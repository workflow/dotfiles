{...}: {
  flake.modules.homeManager.dunst = {...}: {
    services.dunst = {
      enable = true;

      settings = {
        global = {
          browser = "brave";
          dmenu = "fuzzel --dmenu";
          follow = "mouse";
        };
      };
    };
  };
}
