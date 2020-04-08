{ ... }:

{
  services.xserver = {
    layout = "us,gr";
    xkbOptions = "caps:escape, ctrl:ralt_rctrl, grp:alt_space_toggle";
    # xfce overrides these settings
    autoRepeatDelay = 500;
    autoRepeatInterval = 45;
  };
}
