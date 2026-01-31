{...}: {
  flake.modules.nixos.performance = {...}: {
    documentation.man = {
      enable = true;
      generateCaches = false;
    };
  };
}
