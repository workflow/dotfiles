{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.telegram = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".local/share/TelegramDesktop"
      ];
    };

    home.packages = [
      pkgs.telegram-desktop
    ];
  };
}
