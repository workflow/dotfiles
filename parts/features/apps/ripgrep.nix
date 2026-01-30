{...}: {
  flake.modules.homeManager.ripgrep = {...}: {
    programs.ripgrep = {
      enable = true;
      arguments = ["--smart-case"];
    };
  };
}
