{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".cache/cliphist"
    ];
  };

  services.cliphist = {
    enable = true;
    systemdTarget = "sway-session.target";
  };

  home.packages = [pkgs.xdg-utils]; # For image copy/pasting
}
