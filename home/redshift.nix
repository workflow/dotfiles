{...}: {
  services.redshift = {
    enable = true;

    # Until Mozilla is fixed, fetch from https://www.geonames.org/
    # latitude = 38.74724;
    # longitude = -9.24526;
    latitude = 37.61882;
    longitude = -122.3758;

    provider = "manual";
    tray = true;
  };
}
