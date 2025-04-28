{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/thefuck"
    ];
  };

  home.packages = [
    pkgs.thefuck
  ];
}
