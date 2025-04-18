{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  environment.persistence."/persist" = lib.mkIf isImpermanent {
    files = [
      "/etc/nixos/cachix.nix"
    ];
    directories = [
      "/etc/nixos/cachix"
    ];
  };

  environment.systemPackages = [
    pkgs.cachix
  ];
}
