{
  lib,
  isImpermanent,
  ...
}: {
  environment.persistence."/persist/system" = lib.mkIf isImpermanent {
    directories = [
      "/var/lib/bluetooth"
    ];
  };
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
}
