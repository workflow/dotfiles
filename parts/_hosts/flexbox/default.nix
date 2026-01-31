{config, lib, pkgs, ...}: {
  imports = [./hardware-scan.nix];

  # Flexbox-specific settings
  boot.kernelParams = [
    "nvme_core.default_ps_max_latency_us=0"
    "acpiphp.disable=1"
  ];

  # NVIDIA GPU settings
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # SOF audio card power fix
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="pci", KERNELS=="0000:00:1f.3", ATTR{power/control}="on"
  '';

  # LVM on LUKS
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/ae713884-749b-4edb-adbc-b16fe447e956";
      preLVM = true;
    };
  };

  networking.hostName = "flexbox";
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  system.stateVersion = "22.05";
}
