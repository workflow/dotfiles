{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".local/share/Trash"
    ];
  };

  home.packages = [
    pkgs.trash-cli
  ];
}
