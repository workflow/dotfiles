{...}: {
  flake.modules.homeManager.trash-cli = {pkgs, ...}: {
    home.packages = [pkgs.trash-cli];
  };
}
