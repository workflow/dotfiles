{config, lib, pkgs, ...}: {
  imports = [./hardware-scan.nix];

  # LVM on LUKS
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p6";
      preLVM = true;
    };
  };

  # NixOS 26.05 + systemd stage 1: with LVM-over-LUKS, the LV appears after
  # systemd's default device-timeout. See release-notes 26.05 LUKS section.
  fileSystems."/".options = lib.mkAfter ["x-systemd.device-timeout=infinity"];
  fileSystems."/nix".options = lib.mkAfter ["x-systemd.device-timeout=infinity"];
  fileSystems."/persist".options = lib.mkAfter ["x-systemd.device-timeout=infinity"];

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
    path = [pkgs.networkmanager];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.networkmanager}/bin/nmcli radio wifi off";
    };
  };

  system.stateVersion = "24.11";
}
