# GNU binutils, mainly for strings(1)
{...}: {
  flake.modules.homeManager.binutils = {pkgs, ...}: {
    home.packages = [pkgs.binutils];
  };
}
