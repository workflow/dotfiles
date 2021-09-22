{ ... }:

{
  # writes to /etc/X11/xorg.conf.d
  services.xserver = {
    layout = "us,de,ua";
    xkbOptions = "grp:ctrls_toggle,eurosign:e,caps:escape_shifted_capslock,terminate:ctrl_alt_bksp";
  };
}
