{
  lib,
  isImpermanent,
  pkgs,
  secrets,
  ...
}: let
  systemSecrets =
    if secrets ? systemSecrets
    then secrets.systemSecrets {inherit isImpermanent lib pkgs;}
    else {};
in {
  imports =
    [
      ./audio
      ./bluetooth
      ./cachix
      ./desktop
      ./dns
      ./firmware
      ./fonts
      ./io
      ./kernel
      ./kind-killer
      ./networking
      ./nix-ld
      ./performance
      ./power
      ./printing
      ./security
      ./stylix
      ./users
      ./various
      ./video
      ./virtualisation
    ]
    ++ lib.lists.optionals isImpermanent [./impermanence]
    ++ [systemSecrets];
}
