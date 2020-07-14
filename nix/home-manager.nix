{ pkgs, ... }:

let

  sources = import ../nix/sources.nix;
  home-manager = import sources.home-manager {};

in

{
  imports = [ home-manager.nixos ];

  home-manager = {
    users.farlion = import ../home.nix;
    backupFileExtension = "home-manager-backup";
  };
}
