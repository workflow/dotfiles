{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/freerdp" # server keys connected to
      ".config/remmina"
      ".local/share/remmina"
      ".cache/remmina"
    ];
  };

  home.packages = [
    pkgs.remmina
  ];
}
