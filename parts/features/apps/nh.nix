{...}: {
  flake.modules.homeManager.nh = {pkgs, ...}: {
    programs.nh = {
      enable = true;
      flake = "/home/farlion/code/nixos-config";
      # TODO: drop on the nixos-26.11 upgrade. 26.05's nom rejects Determinate Nix's activity type 10113; fixed via nixpkgs#576147 (master only).
      package = pkgs.nh.override {inherit (pkgs.unstable) nix-output-monitor;};
    };
  };
}
