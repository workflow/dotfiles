{ pkgs, ... }:

{
  imports = [
    ./tlp
  ];

  powerManagement.powertop.enable = true;

  services.acpid.acEventCommands = ''
    echo -1 > /sys/module/usbcore/parameters/autosuspend
  '';

}
