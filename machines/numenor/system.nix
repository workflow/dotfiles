# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{pkgs, ...}: {
  # LVM on LUKS
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p6";
      preLVM = true;
    };
  };

  # Needed for ddcutil
  hardware.i2c.enable = true;

  # Plenty of RAM so...
  boot.tmp.useTmpfs = true;

  networking.useDHCP = false;
  networking.interfaces.enp74s0.useDHCP = true;

  networking.hostName = "numenor";

  # Disable Wifi at boot
  systemd.services.disable-wifi = {
    enable = true;
    description = "Disable Wi-Fi at boot";
    after = ["network.target" "NetworkManager.service"];
    wantedBy = ["multi-user.target"];
    path = with pkgs; [networkmanager];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.networkmanager}/bin/nmcli radio wifi off";
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
