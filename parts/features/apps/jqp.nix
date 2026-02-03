# TUI Playground for interacting with jq
{...}: {
  flake.modules.homeManager.jqp = {...}: {
    programs.jqp.enable = true;
  };
}
