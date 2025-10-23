{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/GIMP"
      ".cache/gimp"
    ];
  };

  home.packages = [
    pkgs.gimp
  ];
}
