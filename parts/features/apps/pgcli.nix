{...}: {
  flake.modules.homeManager.pgcli = {...}: {
    programs.pgcli.enable = true;
  };
}
