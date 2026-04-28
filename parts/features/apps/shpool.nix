{...}: {
  flake.modules.homeManager.shpool = {...}: {
    services.shpool = {
      enable = true;
      systemd = true;
    };
  };
}
