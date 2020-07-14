{ pkgs, ... }:

let

  sources = import ./sources.nix;

in
{

  nix = {
    # trusted users for pulling from caches
    trustedUsers = [ "root" "farlion" "@wheel" "@sudo" ];

    binaryCaches = [
      "https://cache.nixos.org/"
      # Add cachix here
    ];

    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
      "nixpkgs-unstable=${sources.nixpkgs-unstable}"
      "nur=${sources.NUR}"
    ];
  };

  nixpkgs = {
    config.allowUnfree = true;
  };
}
