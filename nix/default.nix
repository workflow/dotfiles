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
    ];

    binaryCachePublicKeys = [
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
  };
}
