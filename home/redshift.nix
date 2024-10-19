{...}: {
  services.redshift = {
    enable = true;

    # Until Mozilla is fixed, fetch from https://www.geonames.org/
    latitude = 38.74724;
    longitude = -9.24526;

    provider = "manual";
    tray = true;
  };
}
