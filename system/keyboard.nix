{ ... }:

{
  # writes to /etc/X11/xorg.conf.d
  services.xserver = {
    layout = "us,de,ua,pt";
    # FIXME: Stopped working in 21.11, now setting manually via i3 startup
    #xkbOptions = "grp:ctrls_toggle,eurosign:e,caps:escape_shifted_capslock,terminate:ctrl_alt_bksp";
  };
}
