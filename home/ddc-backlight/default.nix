# Toggle CPU profiles
{pkgs, ...}: let
  ddc-backlight = pkgs.writeShellApplication {
    name = "ddc-backlight";
    runtimeInputs = [pkgs.ddcutil pkgs.coreutils];
    text = builtins.readFile ./scripts/ddc-backlight.sh;
  };
in {
  home.packages = [ddc-backlight];
}
