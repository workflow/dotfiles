{ pkgs, ... }:
{
  # Controlling external screens
  services.ddccontrol.enable = true;
  hardware.i2c.enable = true;
  users.users.farlion.extraGroups = [ "i2c" ];

  # For redshift
  services.geoclue2.enable = true;
}
