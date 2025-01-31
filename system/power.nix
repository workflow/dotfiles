{
  config,
  lib,
  pkgs,
  ...
}: let
  isFlexbox = config.networking.hostName == "flexbox";
in {
  # This will save you money and possibly your life!
  services.thermald.enable = true;

  services.logind.lidSwitch = "suspend-then-hibernate";
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h
  '';

  # Dell-specific power management
  environment.systemPackages = lib.mkIf isFlexbox [
    pkgs.libsmbios
  ];

  services.xserver = {
    # Set DPMS timeouts to zero (any timeouts managed by xidlehook)
    serverFlagsSection = ''
      Option "BlankTime" "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
    '';
  };

  services.cpupower-gui = lib.mkIf isFlexbox {
    enable = true;
  };

  services.tlp = lib.mkIf isFlexbox {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    };
  };
}
