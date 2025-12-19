{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".cache/cliphist"
    ];
  };

  services.cliphist = {
    enable = true;
  };

  # Fix cliphist systemd service to start after Niri is ready
  systemd.user.services.cliphist = {
    Install.WantedBy = lib.mkForce ["niri.service"];
    Unit.Requires = ["niri.service"];
    Unit.After = ["niri.service"];
  };
  systemd.user.services.cliphist-images = {
    Install.WantedBy = lib.mkForce ["niri.service"];
    Unit.Requires = ["niri.service"];
    Unit.After = ["niri.service"];
  };

  home.packages = [pkgs.xdg-utils]; # For image copy/pasting
}
