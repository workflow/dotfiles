{ pkgs, ... }:
{
  home.packages = [ pkgs.unstable.nh ];

  home.sessionVariables = {
    FLAKE = "/home/farlion/code/nixos-config";
  };
}
