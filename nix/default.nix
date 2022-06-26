{ pkgs, ... }:
let

  sources = import ./sources.nix;

  rust-overlay = import sources.rust-overlay;

in
{

  nix = {
    # trusted users for pulling from caches
    trustedUsers = [ "root" "farlion" "@wheel" "@sudo" ];

    binaryCaches = [
      "https://cache.nixos.org/"
      "https://workflow.cachix.org/"
      "https://jupyterwith.cachix.org/"
    ];

    binaryCachePublicKeys = [
      "workflow.cachix.org-1:HhfBXgXCafJxYuATcMDQbC1qsbjF9qJUCchzFZS2zL4="
      "jupyterwith.cachix.org-1:/kDy2B6YEhXGJuNguG1qyqIodMyO4w8KwWH4/vAc7CI="
    ];

    extraOptions = ''
      # For private cachix caches
      netrc-file = /home/farlion/.config/nix/netrc
      experimental-features = nix-command flakes
    '';

    nixPath = [
      "nixpkgs=${sources.nixos}"
      "nixos-config=/etc/nixos/configuration.nix"
      "nixos-hardware=${sources.nixos-hardware}"
      "nixpkgs-unstable=${sources.nixpkgs-unstable}"
      "nur=${sources.NUR}"
    ];

  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [ rust-overlay ];
  };
}
