{pkgs, ...}: let
in {
  home.packages = [
    pkgs.showmethekey
  ];
}
