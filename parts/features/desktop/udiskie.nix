{...}: {
  flake.modules.homeManager.udiskie = {...}: {
    # Indicator icon for automounting USB drives
    services.udiskie = {
      enable = true;
      automount = false;
    };
  };
}
