{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.nixos.power = {
    lib,
    pkgs,
    ...
  }: let
    isFlexbox = cfg.dendrix.hostname == "flexbox";
  in {
    services.thermald.enable = true;

    services.logind = {
      settings = {
        Login = {
          HandleLidSwitch = "suspend-then-hibernate";
          HandleLidSwitchDocked = "lock";
          HandleLidSwitchExternalPower = "lock";
        };
      };
    };
    systemd.sleep.extraConfig = ''
      HibernateDelaySec=1h
    '';

    environment.systemPackages =
      []
      ++ lib.lists.optional isFlexbox pkgs.libsmbios;

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

    services.upower.enable = true;
  };
}
