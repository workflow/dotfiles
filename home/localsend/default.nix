{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".local/share/org.localsend.localsend_app"
    ];
  };

  home.packages = [
    pkgs.localsend
  ];
}
