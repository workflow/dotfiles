{
  lib,
  isImpermanent,
  secrets,
  ...
}: {
  imports =
    [
      ./audio
      ./cachix
      ./desktop
      ./dns
      ./firmware
      ./fonts
      ./io
      ./kind-killer
      ./networking
      ./nix-ld
      ./performance
      ./power
      ./printing
      ./security
      ./stylix
      ./various
      ./video
      ./virtualisation
    ]
    ++ lib.lists.optionals isImpermanent [./impermanence]
    ++ lib.lists.optionals (secrets ? systemSecrets) secrets.systemSecrets;
}
