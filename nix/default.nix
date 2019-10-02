{ ... }:

{
  nix.binaryCaches =
    [ "https://cache.nixos.org/" "https://alexpeits.cachix.org" ];

  nix.binaryCachePublicKeys =
    [ "alexpeits.cachix.org-1:O5CoFuKPb8twVOp1OrfSOPfgaEo5X5xlIqGg6dMEgB4=" ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ./overlay.nix { })
      (import ../packages/overlay.nix { })
    ];
  };
}
