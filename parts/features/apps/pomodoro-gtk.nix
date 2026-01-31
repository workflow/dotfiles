{...}: {
  flake.modules.homeManager.pomodoro-gtk = {pkgs, ...}: {
    home.packages = [pkgs.pomodoro-gtk];
  };
}
