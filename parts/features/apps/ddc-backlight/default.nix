{...}: {
  flake.modules.homeManager.ddc-backlight = {lib, osConfig, pkgs, ...}: let
    ddc-backlight = pkgs.writeShellApplication {
      name = "ddc-backlight";
      runtimeInputs = [pkgs.ddcutil pkgs.coreutils pkgs.util-linux];
      text = builtins.readFile ./scripts/ddc-backlight.sh;
    };
  in
    lib.mkIf (!osConfig.dendrix.isLaptop) {
      home.packages = [ddc-backlight pkgs.ddcutil];
    };
}
