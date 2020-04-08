{ pkgs, ... }:

let

  tpacpi-bat = pkgs.callPackage ./tpacpi-bat.nix { };

in {
  imports = [ ./tlp.nix ];

  powerManagement.powertop.enable = true;

  services.acpid.acEventCommands = ''
    echo -1 > /sys/module/usbcore/parameters/autosuspend
  '';

  environment.systemPackages = [ tpacpi-bat ];

}
