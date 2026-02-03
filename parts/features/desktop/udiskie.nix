{...}: {
  flake.modules.homeManager.udiskie = {
    lib,
    pkgs,
    ...
  }: {
    # Indicator icon for automounting USB drives
    services.udiskie = {
      enable = true;
      automount = false;
    };

    # Ensure udiskie starts after the Niri session is up, to avoid tray race conditions
    systemd.user.services.udiskie = {
      Unit = {
        After = ["niri.service" "graphical-session.target"];
        Wants = ["graphical-session.target"];
        # Relax environment conditions in case defaults are too strict for Niri
        ConditionEnvironment = lib.mkForce [];
      };
      Service = {
        # Small delay to ensure Wayland environment and tray are ready
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
        Restart = lib.mkForce "on-failure";
        RestartSec = "5";
      };
    };
  };
}
