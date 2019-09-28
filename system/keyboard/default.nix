{ ... }:

{

  services.xserver.layout = "us,gr";
  services.xserver.xkbOptions =
    "caps:escape, ctrl:ralt_rctrl, grp:alt_space_toggle";
  # these don't really make a difference with xfce, so they're also being set
  # in services.xserver.desktopManager.extraSessionCommands
  services.xserver.autoRepeatDelay = 500;
  services.xserver.autoRepeatInterval = 45;
}
