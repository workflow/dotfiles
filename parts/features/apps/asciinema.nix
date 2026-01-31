{...}: {
  flake.modules.homeManager.asciinema = {...}: {
    programs.asciinema = {
      enable = true;
    };
  };
}
