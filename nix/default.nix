{ pkgs, ... }:

let

  sources = import ./sources.nix;

in {

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://alexpeits.cachix.org"
      "https://alexpeits-travis.cachix.org"
    ];

    binaryCachePublicKeys = [
      "alexpeits.cachix.org-1:O5CoFuKPb8twVOp1OrfSOPfgaEo5X5xlIqGg6dMEgB4="
      "alexpeits-travis.cachix.org-1:V3Rz9GshL7QTfajKGoUpW8PwqQZSdWmjTK2f/VB1/do="
    ];

    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
      "nixpkgs-master=${sources.nixpkgs-master}"
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
