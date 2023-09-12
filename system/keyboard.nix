{ pkgs, ... }:
{

  # Enable Logitech K380 FN Lock
  # Writes to /etc/udev/rules.d/99-local.rules
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="hidraw", KERNEL=="hidraw*", SUBSYSTEMS=="hid", KERNELS=="*:046D:B342.*", RUN+="${pkgs.bash}/bin/bash -c \"echo -ne '\x10\xff\x0b\x1e\x00\x00\x00' > /dev/%k\""
  '';

  services.ratbagd.enable = true;

}
