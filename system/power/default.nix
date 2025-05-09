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

  services.auto-cpufreq = {
    enable = true;
    settings = {};
  };
  security.sudo.extraRules = [
    {
      users = ["farlion"];
      commands = [
        {
          command = "/run/current-system/sw/bin/auto-cpufreq --force performance";
          options = ["NOPASSWD" "SETENV"];
        }
        {
          command = "/run/current-system/sw/bin/auto-cpufreq --force powersave";
          options = ["NOPASSWD" "SETENV"];
        }
        {
          command = "/run/current-system/sw/bin/auto-cpufreq --force reset";
          options = ["NOPASSWD" "SETENV"];
        }
      ];
    }
  ];
}
