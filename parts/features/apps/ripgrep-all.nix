{...}: {
  flake.modules.homeManager.ripgrep-all = {...}: {
    programs.ripgrep-all.enable = true;
  };
}
