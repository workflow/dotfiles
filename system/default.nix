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
      ./boot
      ./cachix
      ./desktop
      ./dns
      ./firmware
      ./fonts
      ./io
      ./kernel
      ./kind-killer
      ./localsend # Apple Airdrop OSS
      ./networking
      ./nix-ld
      ./performance
      ./power
      ./printing
      ./scrutiny # Hard Drive S.M.A.R.T Monitoring, historical trends
      ./security
      ./smb
      ./stylix
      ./syncthing
      ./systemd
      ./users
      ./various
      ./video
      ./virtualisation
      ./wireshark
    ]
    ++ lib.lists.optionals isImpermanent [./impermanence]
    ++ [systemSecrets];
}
