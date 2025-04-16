{
  inputs,
  pkgs,
  ...
}: let
  packages = pkgs.callPackage ./packages {inherit inputs;};
in {
  imports = [
    ./nix
    ./specialisations/light
    ./system
  ];

  environment.systemPackages = packages;
}
