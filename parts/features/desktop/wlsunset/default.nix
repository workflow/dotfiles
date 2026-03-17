# Day/night gamma adjustments for Wayland
{...}: {
  flake.modules.homeManager.wlsunset = {pkgs, ...}: {
    home.packages = [
      pkgs.wlsunset
    ];
  };
}
