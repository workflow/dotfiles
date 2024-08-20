# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in {
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false; # Disable this after first installation to not wear out EFI storage
  boot.consoleLogLevel = 7;

  # https://lore.kernel.org/linux-nvme/YnR%2FFiWbErNGXIx+@kbusch-mbp/T/
  boot.kernelParams = ["nvme_core.default_ps_max_latency_us=0" "acpiphp.disable=1"];

  # Temporary Audio fix on Kernel 6.6.37+
  # See https://github.com/NixOS/nixpkgs/issues/330685
  # boot.extraModprobeConfig = ''
  #   options snd-hda-intel dmic_detect=0
  # '';
  # boot.kernelPatches = [
  #   {
  #     name = "fix-1";
  #     patch = builtins.fetchurl {
  #       url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/patch/sound/soc/soc-topology.c?id=e0e7bc2cbee93778c4ad7d9a792d425ffb5af6f7";
  #       sha256 = "sha256:1y5nv1vgk73aa9hkjjd94wyd4akf07jv2znhw8jw29rj25dbab0q";
  #     };
  #   }
  #   {
  #     name = "fix-2";
  #     patch = builtins.fetchurl {
  #       url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/patch/sound/soc/soc-topology.c?id=0298f51652be47b79780833e0b63194e1231fa34";
  #       sha256 = "sha256:14xb6nmsyxap899mg9ck65zlbkvhyi8xkq7h8bfrv4052vi414yb";
  #     };
  #   }
  # ];
  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_6.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
        sha256 = "sha256-85dud3CGlP5KH40TB8MVyKNsvFjwOKOOAGuR4pofMhQ=";
      };
      version = "6.6.37";
      modDirVersion = "6.6.37";
    };
  });

  # GPU
  environment.systemPackages = [nvidia-offload];
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  # Better performance according to https://github.com/chjj/compton/issues/227
  services.xserver.screenSection = ''
    Option "metamodes" "nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
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
