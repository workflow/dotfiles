{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/nautilus"
      ".local/share/nautilus"
    ];
  };

  home.packages = [
    pkgs.nautilus
  ];
}
