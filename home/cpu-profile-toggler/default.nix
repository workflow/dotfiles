# Toggle CPU profiles
{pkgs, ...}: let
  cpu-profile-toggler = pkgs.writeShellApplication {
    name = "cpu-profile-toggler";
    runtimeInputs = [];
    text = builtins.readFile ./scripts/cpu-profile-toggler.sh;
  };
in {
  home.packages = [cpu-profile-toggler];
}
