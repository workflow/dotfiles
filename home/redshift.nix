{ ... }:
{
  services.redshift = {
    enable = true;

    provider = "geoclue2";
    tray = true;
  };
}
