# Day/night gamma adjustments for Wayland
{...}: {
  services.wlsunset = {
    enable = true;
    latitude = 38.7;
    longitude = -9.1;
    systemdTarget = "sway-session.target";
  };
}
