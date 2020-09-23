{ config, lib, ... }:

{
  boot.blacklistedKernelModules = [ "nouveau" ];

  services.logind.lidSwitch = "lock";

  # For better T480 CPU throttling, see https://github.com/erpalma/throttled
  services.throttled.enable = lib.mkIf (config.networking.hostName == "nixbox") true;

  # Tmp get rid of this
  swapDevices = lib.mkIf (config.networking.hostName == "nixbox") [
    {
      device = "/var/swap";
      size = 1024 * 32 * 2; # twice the RAM should leave enough space for hibernation
    }
  ];
  #boot.resumeDevice = "/dev/mapper/cryptroot";

  # Writes to /etc/sysctl.d/60-nixos.conf
  boot.kernel.sysctl = {
    "vm.swappiness" = 0;
  };

  services.hardware.bolt.enable = true;
}
