{...}: {
  flake.modules.homeManager.ddc-backlight = {pkgs, ...}: let
    ddc-backlight = pkgs.writeShellApplication {
      name = "ddc-backlight";
      runtimeInputs = [pkgs.ddcutil pkgs.coreutils pkgs.util-linux];
      text = builtins.readFile ./scripts/ddc-backlight.sh;
    };
  in {
    home.packages = [ddc-backlight pkgs.ddcutil];
  };
}
