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
}

