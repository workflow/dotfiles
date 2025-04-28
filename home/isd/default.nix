{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/isd_tui"
      ".local/share/isd_tui"
      ".cache/isd_tui"
    ];
  };

  home.packages = [
    pkgs.unstable.isd
  ];
}
