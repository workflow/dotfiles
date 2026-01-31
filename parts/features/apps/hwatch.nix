{...}: {
  flake.modules.homeManager.hwatch = {pkgs, ...}: {
    home.packages = [pkgs.hwatch];
  };
}
