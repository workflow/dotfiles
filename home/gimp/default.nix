{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/GIMP"
      ".cache/gimp"
    ];
  };

  home.packages = [
    pkgs.gimp
  ];
}
