{ pkgs, ... }:

let

  sources = pkgs.callPackage ./sources.nix { };

in {

  nix = {
    binaryCaches =
      [ "https://cache.nixos.org/" "https://alexpeits.cachix.org" ];

    binaryCachePublicKeys =
      [ "alexpeits.cachix.org-1:O5CoFuKPb8twVOp1OrfSOPfgaEo5X5xlIqGg6dMEgB4=" ];

    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
      "nixos-beta=${sources.nixos-beta}"
    ];
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ./overlay.nix { })
      (import ../packages/overlay.nix { })
    ];
  };
}
