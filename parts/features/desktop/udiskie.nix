{...}: {
  flake.modules.homeManager.udiskie = {
    lib,
    pkgs,
    ...
  }: {
    services.udiskie = {
      enable = true;
      automount = false;
    };

    systemd.user.services.udiskie = {
      Unit = {
        After = ["niri.service" "graphical-session.target"];
        Wants = ["graphical-session.target"];
        ConditionEnvironment = lib.mkForce [];
      };
      Service = {
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
        Restart = lib.mkForce "on-failure";
        RestartSec = "5";
      };
    };
  };
}
