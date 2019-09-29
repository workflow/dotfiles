{ ... }:

{

  services.xserver.layout = "us,gr";
  services.xserver.xkbOptions =
    "caps:escape, ctrl:ralt_rctrl, grp:alt_space_toggle";
  # xfce overrides these settings
  services.xserver.autoRepeatDelay = 500;
  services.xserver.autoRepeatInterval = 45;
}
