{ pkgs, ... }:
{

  security.sudo.extraConfig = ''
    Defaults:root,%wheel timestamp_timeout=30
  '';

  services.fwupd.enable = true;
}
