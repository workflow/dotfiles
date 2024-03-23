{ config, lib, ... }:
let
  isFlexbox = config.networking.hostName == "flexbox";
in
{
  # This will save you money and possibly your life!
  services.thermald.enable = true;

  services.logind.lidSwitch = "suspend-then-hibernate";
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h
  '';

  services.tlp = lib.mkIf isFlexbox {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      # Battery charge thresholds - should help to prolong battery life
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below start to charge
      STOP_CHARGE_THRESH_BAT0 = 85; # 85 and above stop charging
    };
  };
}

