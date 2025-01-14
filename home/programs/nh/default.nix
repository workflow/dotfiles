{pkgs, ...}: {
  home.packages = [pkgs.nh];

  home.sessionVariables = {
    FLAKE = "/home/farlion/code/nixos-config";
  };
}
