{pkgs, ...}: let
  touchpad-toggle = import ./scripts/touchpad-toggle.nix {inherit pkgs;};
in {
  # Enable Logitech K380 FN Lock
  # Disable Touchpad when External Mouse Connected
  # Writes to /etc/udev/rules.d/99-local.rules
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="hidraw", KERNEL=="hidraw*", SUBSYSTEMS=="hid", KERNELS=="*:046D:B342.*", RUN+="${pkgs.bash}/bin/bash -c \"echo -ne '\x10\xff\x0b\x1e\x00\x00\x00' > /dev/%k\""
    ACTION=="change", SUBSYSTEM=="power_supply", RUN+="${pkgs.stdenv.shell} ${touchpad-toggle}/bin/touchpad-toggle"
  '';

  services.ratbagd.enable = true;

  # Writes to /etc/X11/xorg.conf.d
  services.libinput = {
    enable = true;
    touchpad.disableWhileTyping = true;
  };
}
