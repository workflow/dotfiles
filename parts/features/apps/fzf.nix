{...}: {
  flake.modules.homeManager.fzf = {...}: {
    programs.fzf = {
      enable = true;
      defaultCommand = "rg --files --no-ignore-vcs --hidden";
    };
  };
}
