# Onboard Keyboard Layout
{...}: {
  flake.modules.homeManager.onboard = {pkgs, ...}: {
    home.packages = [pkgs.onboard];
  };
}
