# Why is this running?
{...}: {
  flake.modules.homeManager.witr = {pkgs, ...}: {
    home.packages = [pkgs.unstable.witr];
  };
}
