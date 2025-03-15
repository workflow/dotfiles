# Day/night gamma adjustments for Wayland
{...}: {
  services.wlsunset = {
    enable = true;
    latitude = 47.2;
    longitude = 11.3;
    systemdTarget = "sway-session.target";
  };
}
