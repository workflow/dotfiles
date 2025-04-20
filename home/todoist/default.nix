{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/Todoist"
    ];
  };

  home.packages = [
    pkgs.todoist-electron
  ];
}
