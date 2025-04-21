# Linux Firmware Updates
{
  lib,
  isImpermanent,
  ...
}: {
  environment.persistence."/persist/system" = lib.mkIf isImpermanent {
    directories = [
      "/var/lib/fwupd"
    ];
  };

  services.fwupd.enable = true;
}
