{
  lib,
  isImpermanent,
  secrets,
  ...
}: {
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
    ++ lib.lists.optionals (secrets ? systemSecrets) secrets.systemSecrets;
}
