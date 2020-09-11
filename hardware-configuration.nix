{ config, lib, ... }:

{
  boot.blacklistedKernelModules = [ "nouveau" ];

  services.logind.lidSwitch = "lock";

  # For better T480 CPU throttling, see https://github.com/erpalma/throttled
  services.throttled.enable = lib.mkIf (config.networking.hostName == "nixbox") true;

  swapDevices = [
    {
      device = "/var/swap";
      size = 1024 * 32 * 2; # twice the RAM should leave enough space for hibernation
    }
  ];

  services.hardware.bolt.enable = true;

}
