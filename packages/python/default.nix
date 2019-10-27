{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.python37 pkgs.python37Packages.black ];
}
