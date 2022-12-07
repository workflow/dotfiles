{ pkgs, ... }:
{
  services.ddccontrol.enable = true;
  hardware.i2c.enable = true;
  users.users.farlion.extraGroups = [ "i2c" ];
}
