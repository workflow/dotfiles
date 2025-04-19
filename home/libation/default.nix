{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      "Libation"
      ".local/share/Libation"
    ];
  };

  home.packages = [
    pkgs.libation
  ];
}
