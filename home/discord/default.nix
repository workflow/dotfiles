{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/discord"
    ];
  };

  home.packages = [
    pkgs.discord
  ];
}
