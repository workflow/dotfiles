{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.libation
  ];

  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      "Libation"
      ".local/share/Libation"
    ];
  };
}
