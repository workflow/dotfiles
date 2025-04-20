{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/Bitwarden"
    ];
  };

  home.packages = [
    pkgs.bitwarden
    pkgs.bitwarden-cli
  ];
}
