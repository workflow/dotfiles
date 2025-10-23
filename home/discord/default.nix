{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/discord"
    ];
  };

  home.packages = [
    pkgs.discord
  ];
}
