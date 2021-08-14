# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix

      /home/farlion/nixos-config/configuration.nix
      /home/farlion/nixos-config/hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p4";
      preLVM = true;
    };
  };

  networking.hostName = "flexbox";

  # The global useDHCP flag is deprecated, therefore explicitly set to
  # false here. Per-interface useDHCP will be mandatory in the future,
  # so this generated config replicates the default behaviour.
  networking.useDHCP = false;
  #networking.interfaces.enp164s0u1.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database
  # versions on your system were taken. It‘s perfectly fine and
  # recommended to leave this value at the release version of the first
  # install of this system. Before changing this value read the
  # documentation for this option (e.g. man configuration.nix or on
  # https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
