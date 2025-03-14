# Indicator icon for automounting USB drives
{...}: {
  services.udiskie = {
    enable = true;
    automount = false;
    tray = "never"; # Tray icon is currently broken under swaybar :(, since it doesn't support SNI
  };
}
