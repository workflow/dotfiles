{...}: {
  flake.modules.nixos.performance = {...}: {
    documentation.man = {
      enable = true;
      generateCaches = false; # Used for apropos and the -k option of man, but significantly slows down builds
    };
  };
}
