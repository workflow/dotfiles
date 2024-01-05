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
      max-jobs = 24;
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
    config.permittedInsecurePackages = [
      "electron-19.1.9" # For etcher
      "electron-25.9.0" # For todoist-electron
    ];
  };
}
