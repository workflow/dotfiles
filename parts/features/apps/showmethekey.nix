{...}: {
  flake.modules.homeManager.showmethekey = {pkgs, ...}: {
    home.packages = [pkgs.showmethekey];
  };
}
