{...}: {
  flake.modules.homeManager.nh = {...}: {
    programs.nh = {
      enable = true;
      flake = "/home/farlion/code/nixos-config";
    };
  };
}
