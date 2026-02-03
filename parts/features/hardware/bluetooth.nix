# Bluetooth TUI
{...}: {
  flake.modules.nixos.bluetooth = {config, lib, ...}: {
    environment.persistence."/persist/system" = lib.mkIf config.dendrix.isImpermanent {
      directories = [
        "/var/lib/bluetooth"
      ];
    };
    services.blueman.enable = true;
    hardware.bluetooth.enable = true;
  };

  flake.modules.homeManager.bluetuith = {...}: {
    programs.bluetuith = {
      enable = true;
    };
  };
}
