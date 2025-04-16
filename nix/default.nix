{pkgs, ...}: {
  nix = {
    settings = {
      # trusted users for pulling from caches
      trusted-users = ["root" "farlion" "@wheel" "@sudo"];
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
      ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    nixPath = [
      "nixpkgs=${pkgs.path}"
      "nixos-unstable=${pkgs.unstable.path}"
    ];
  };

  nixpkgs = {
    config.allowUnfree = true;
  };
}
