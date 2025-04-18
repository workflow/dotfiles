{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.bitwarden
    pkgs.bitwarden-cli
  ];

  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/Bitwarden"
    ];
  };
}
