{...}: {
  flake.modules.nixos.power = {
    config,
    lib,
    pkgs,
    ...
  }: let
    isFlexbox = config.dendrix.hostname == "flexbox";
  in {
    # This will save you money and possibly your life!
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

    # Dbus Service provding historical battery stats, access to external device batteries... etc.
    services.upower.enable = true;
  };
}
