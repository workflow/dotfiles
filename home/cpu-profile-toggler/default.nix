# Toggle CPU profiles
{pkgs, ...}: let
  cpu-profile-toggler = pkgs.writeShellApplication {
    name = "cpu-profile-toggler";
    runtimeInputs = with pkgs; [gnugrep auto-cpufreq linuxKernel.packages.linux_zen.cpupower];
    text = builtins.readFile ./scripts/cpu-profile-toggler.sh;
  };
in {
  home.packages = [cpu-profile-toggler];
}
