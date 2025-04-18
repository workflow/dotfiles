{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.gimp
  ];

  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/GIMP"
      ".cache/gimp"
    ];
  };
}
