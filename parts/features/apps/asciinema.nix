{...}: {
  flake.modules.homeManager.asciinema = {...}: {
    programs.asciinema = {
      enable = true;
      settings.server.url = "https://asciinema.hyena-byzantine.ts.net";
    };
  };
}
