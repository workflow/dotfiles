{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/nautilus"
      ".local/share/nautilus"
    ];
  };

  home.packages = [
    pkgs.nautilus
  ];
}
