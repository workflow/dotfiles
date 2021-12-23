# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
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

  # Switch to a newer kernel (>5.13) for audio and GPU support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Fix audio
  boot.kernelPatches = [
    {
      name = "enable-soundwire-drivers";
      patch = null;
      extraConfig = ''
        SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES y
        SND_SOC_INTEL_SOUNDWIRE_SOF_MACH m
        SND_SOC_RT1308 m
      '';
      ignoreConfigErrors = true;
    }
  ];
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto, enable_msi=1
  '';

  # GPU
  environment.systemPackages = [ nvidia-offload ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  # Better performance according to https://github.com/chjj/compton/issues/227
  services.xserver.screenSection = ''
    Option "metamodes" "nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
  '';

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
