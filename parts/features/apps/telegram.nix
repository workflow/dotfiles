{...}: {
  flake.modules.homeManager.telegram = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".local/share/TelegramDesktop"
      ];
    };

    home.packages = [
      pkgs.telegram-desktop
    ];
  };
}
