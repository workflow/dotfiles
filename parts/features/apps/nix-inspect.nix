{...}: {
  flake.modules.homeManager.nix-inspect = {pkgs, ...}: {
    home.packages = [
      pkgs.nix-inspect
    ];
  };
}
