# Display number of systemd errors and warnings in last 10 minutes
{...}: {
  flake.modules.homeManager.systemd-errors-and-warnings-counter = {pkgs, ...}: let
    systemd-errors-and-warnings-counter = pkgs.writeShellApplication {
      name = "systemd-errors-and-warnings-counter";
      runtimeInputs = [pkgs.systemd pkgs.coreutils];
      text = builtins.readFile ./_scripts/systemd-errors-and-warnings-counter.sh;
    };
  in {
    home.packages = [systemd-errors-and-warnings-counter];
  };
}
