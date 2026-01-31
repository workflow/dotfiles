{...}: {
  flake.modules.nixos.cachix = {pkgs, ...}: {
    environment.systemPackages = [pkgs.cachix];
  };
}
