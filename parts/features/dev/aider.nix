{...}: {
  flake.modules.homeManager.aider = {...}: {
    programs.aider-chat = {
      enable = true;
    };
  };
}
