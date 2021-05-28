{ config, lib, ... }:

{
  boot.blacklistedKernelModules = [ "nouveau" ];

  services.logind.lidSwitch = "lock";

  # For better T480 CPU throttling, see https://github.com/erpalma/throttled
  services.throttled.enable = lib.mkIf (config.networking.hostName == "nixbox") true;

  # Writes to /etc/sysctl.d/60-nixos.conf
  boot.kernel.sysctl = {
    "vm.swappiness" = 0;
  };

  services.hardware.bolt.enable = true;

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
}
