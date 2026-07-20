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
    systemd.sleep.settings.Sleep = {
      HibernateDelaySec = "1h";
    };

    environment.systemPackages =
      []
      ++ lib.lists.optional isFlexbox pkgs.libsmbios; # Dell-specific power management

    # dell_wmi_ddv (Dell Data Vault diagnostics) has a runtime-PM bug: its hwmon
    # child gets resumed while the parent BAT0 device is suspended ("hwmon: PM:
    # parent BAT0 should not be sleeping"), which leaves the battery's sysfs
    # subtree unreadable until an AC replug re-registers the device. Waybar then
    # logs "No batteries." and the battery icon disappears. The module is purely
    # diagnostic (battery temp sensor, eppid) and provides nothing we use.
    boot.blacklistedKernelModules = lib.lists.optional isFlexbox "dell_wmi_ddv";

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
