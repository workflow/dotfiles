{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.cachix
  ];
}
