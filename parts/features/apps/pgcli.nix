# Actually usable PostgreSQL CLI
{...}: {
  flake.modules.homeManager.pgcli = {...}: {
    programs.pgcli.enable = true;
  };
}
