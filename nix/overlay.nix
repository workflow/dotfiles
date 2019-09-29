{ }:
self: super:

{
  myLib = super.callPackage ../lib { pkgs = super; };
}
