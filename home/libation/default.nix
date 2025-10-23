{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      "Libation"
      ".local/share/Libation"
    ];
  };

  home.packages = [
    pkgs.libation
  ];
}
