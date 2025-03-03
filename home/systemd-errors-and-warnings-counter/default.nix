# Display number of systemd errors and warnings in last 10 minutes
{pkgs, ...}: let
  systemd-errors-and-warnings-counter = pkgs.writeShellApplication {
    name = "systemd-errors-and-warnings-counter";
    runtimeInputs = [pkgs.ddcutil pkgs.coreutils];
    text = builtins.readFile ./scripts/systemd-errors-and-warnings-counter.sh;
  };
in {
  home.packages = [systemd-errors-and-warnings-counter];
}
