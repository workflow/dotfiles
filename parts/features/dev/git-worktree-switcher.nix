{...}: {
  flake.modules.homeManager.git-worktree-switcher = {...}: {
    programs.git-worktree-switcher.enable = true;
  };
}
