{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/qalculate"
      ".local/share/qalculate"
    ];
  };

  home.packages = [
    pkgs.qalculate-gtk
  ];
}
