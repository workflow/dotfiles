{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/BraveSoftware"
      ".cache/BraveSoftware"
    ];
  };

  home.packages = [
    pkgs.brave
  ];
}
