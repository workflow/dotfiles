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
    ];

    binaryCachePublicKeys = [
      "workflow.cachix.org-1:HhfBXgXCafJxYuATcMDQbC1qsbjF9qJUCchzFZS2zL4="
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
      "nixos-unstable=${sources.nixos-unstable}"
      "nur=${sources.NUR}"
    ];
  };

  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "libav-11.12"
    ];

  };
}
