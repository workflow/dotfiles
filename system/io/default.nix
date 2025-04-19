{...}: {
  # Writes to /etc/X11/xorg.conf.d
  services.libinput = {
    enable = true;
    touchpad = {
      disableWhileTyping = true;
      accelProfile = "adaptive";
      accelSpeed = "0.2";
    };
  };
}
