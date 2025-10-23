{
  isImpermanent,
  lib,
  pkgs,
  ...
}: let
  cliphist-fuzzel-img = pkgs.writeShellApplication {
    bashOptions = [
      "nounset"
      "pipefail"
    ];
    name = "cliphist-fuzzel-img";
    runtimeInputs = [pkgs.unstable.fuzzel pkgs.cliphist pkgs.imagemagick];
    text = builtins.readFile ./scripts/cliphist-fuzzel-img.sh;
  };
in {
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

  home.packages = [cliphist-fuzzel-img pkgs.xdg-utils]; # For image copy/pasting
}
