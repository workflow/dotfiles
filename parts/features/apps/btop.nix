{...}: {
  flake.modules.homeManager.btop = {...}: {
    programs.btop.enable = true;
  };
}
