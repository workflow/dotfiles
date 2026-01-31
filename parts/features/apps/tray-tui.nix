{...}: {
  flake.modules.homeManager.tray-tui = {...}: {
    programs.tray-tui = {
      enable = true;
    };
  };
}
