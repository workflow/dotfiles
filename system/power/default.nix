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

  environment.systemPackages =
    []
    ++ lib.lists.optional isFlexbox pkgs.libsmbios; # Dell-specific power management

  services.auto-cpufreq = {
    enable = true;
    settings = {};
  };

  security.sudo.extraRules = [
    {
      users = ["farlion"];
      commands = [
        {
          command = "${pkgs.auto-cpufreq}/bin/auto-cpufreq --force *";
          options = ["NOPASSWD" "SETENV"];
        }
        {
          command = "/run/current-system/sw/bin/auto-cpufreq --force *";
          options = ["NOPASSWD" "SETENV"];
        }
      ];
    }
  ];
}
