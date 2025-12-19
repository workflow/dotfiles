{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/Bitwarden"
    ];
  };

  home.packages = [
    pkgs.bitwarden-desktop
    pkgs.bitwarden-cli
  ];
}
