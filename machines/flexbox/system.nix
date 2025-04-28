# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{...}: {
  # https://lore.kernel.org/linux-nvme/YnR%2FFiWbErNGXIx+@kbusch-mbp/T/
  boot.kernelParams = ["nvme_core.default_ps_max_latency_us=0" "acpiphp.disable=1"];

  # GPU
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Disable power saving for fixing Comet Lake Audio Card (SOF) breaking after suspend
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
  system.stateVersion = "22.05"; # Did you read the comment?
}
