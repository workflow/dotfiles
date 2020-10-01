{ pkgs, ... }:
{

  users.groups.plugdev = { };
  users.users.farlion.extraGroups = [ "plugdev" ];

  hardware.ledger.enable = true;
}
