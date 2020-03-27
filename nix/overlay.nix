{ }:
self: super:

{
  myLib = super.callPackage ../lib.nix { pkgs = super; };
}
