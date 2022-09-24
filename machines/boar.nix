{ config, lib, pkgs, ... }:

{

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "vmd" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/647ff1a6-e9a1-425b-99ee-806fd2dc25d5";
      fsType = "ext4";
      # TODO: Move to hardware-overrides
      options = [ "noatime" "nodiratime" ]; # SSD Optimizations
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/F41C-8BCE";
      fsType = "vfat";
    };

  fileSystems."/mnt/data" =
    {
      device = "/dev/disk/by-uuid/6015af63-1a48-4f8f-aa7e-db95bdaf1907";
      fsType = "ext4";
    };

  fileSystems."/mnt/data-b" =
    {
      device = "/dev/disk/by-uuid/ad3ed77b-9f50-4557-9712-9f85005ff07a";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/61d5dd00-b05f-4d52-9eb7-2124ed6b81af"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    memtest86.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = false; # Disable this after first installation to not wear out EFI storage

  # GPU
  services.xserver.videoDrivers = [ "nvidia" ];
  # Switching to beta for https://forums.developer.nvidia.com/t/bug-nvidia-v495-29-05-driver-spamming-dbus-enabled-applications-with-invalid-messages/192892/36
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  # LUKS over LVM
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/74d4c5f3-f5fe-4aba-ac7a-56b0d28efc64";
      preLVM = true;
    };
    data = {
      device = "/dev/disk/by-uuid/85dd7178-c2b9-4b9a-93d4-9076221d3293";
      preLVM = true;
    };
    data-b-enc = {
      device = "/dev/disk/by-uuid/3c852f71-6ae8-4c1f-86ff-19ca0d18d33a";
      preLVM = true;
    };
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.eth0.useDHCP = true;

  networking.hostName = "boar";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
