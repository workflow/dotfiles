{...}: {
  flake.modules.homeManager.tomat = {...}: {
    services.tomat = {
      enable = true;
    };
  };
}
