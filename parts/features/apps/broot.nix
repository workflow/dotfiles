{...}: {
  flake.modules.homeManager.broot = {...}: {
    programs.broot.enable = true;
  };
}
