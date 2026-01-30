{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.nixos.bluetooth = {lib, ...}: {
    environment.persistence."/persist/system" = lib.mkIf cfg.dendrix.isImpermanent {
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
