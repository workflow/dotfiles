# screenkey for Wayland, show key presses
{...}: {
  flake.modules.homeManager.showmethekey = {pkgs, ...}: {
    home.packages = [pkgs.showmethekey];
  };
}
