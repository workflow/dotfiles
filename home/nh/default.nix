{pkgs, ...}: {
  home.packages = [pkgs.nh];

  home.sessionVariables = {
    NH_FLAKE = "/home/farlion/code/nixos-config";
  };
}
