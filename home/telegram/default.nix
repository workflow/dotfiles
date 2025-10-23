{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".local/share/TelegramDesktop"
    ];
  };

  home.packages = [
    pkgs.tdesktop
  ];
}
