{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".local/share/TelegramDesktop"
    ];
  };

  home.packages = [
    pkgs.tdesktop
  ];
}
