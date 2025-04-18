{
  lib,
  isImpermanent,
  secrets,
  ...
}: {
  imports =
    [
      ./audio.nix
      ./cachix
      ./desktop.nix
      ./dns.nix
      ./firmware
      ./fonts.nix
      ./io
      ./kind-killer
      ./ledgerlive.nix
      ./networking
      ./nix-ld.nix
      ./performance.nix
      ./power.nix
      ./printing.nix
      ./security.nix
      ./steam.nix
      ./stylix
      ./various
      ./video
      ./virtualisation.nix
    ]
    ++ lib.lists.optionals isImpermanent [./impermanence]
    ++ lib.lists.optionals (secrets ? systemSecrets) secrets.systemSecrets;
}
