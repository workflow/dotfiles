{ pkgs, ... }:
{

  nix = {
    settings = {
      # trusted users for pulling from caches
      trusted-users = [ "root" "farlion" "@wheel" "@sudo" ];
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
      ];
    };

    extraOptions = ''
      # For private cachix caches
      netrc-file = /home/farlion/.config/nix/netrc
      experimental-features = nix-command flakes
    '';

    nixPath = [
      "nixpkgs=${pkgs.path}"
      "nixpkgs-unstable=${pkgs.unstable.path}"
    ];
  };

  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [ "electron-12.2.3" ]; # For etcher
  };
}
