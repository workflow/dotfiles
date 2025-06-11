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
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".cache/cliphist"
    ];
  };

  services.cliphist = {
    enable = true;
    systemdTargets = ["sway-session.target"];
  };

  home.packages = [cliphist-fuzzel-img pkgs.xdg-utils]; # For image copy/pasting
}
