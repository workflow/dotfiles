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
      "https://workflow.cachix.org/"
      "https://hyperion.cachix.org/"
    ];

    binaryCachePublicKeys = [
      "workflow.cachix.org-1:HhfBXgXCafJxYuATcMDQbC1qsbjF9qJUCchzFZS2zL4="
      "hyperion.cachix.org-1:uVV2qr8RIPYHijXSUA/2D24dbLGFDxkhDy4uYQ/LKuw="
    ];

    extraOptions = ''
      # For private cachix caches
      netrc-file = /home/farlion/.config/nix/netrc
    '';

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
