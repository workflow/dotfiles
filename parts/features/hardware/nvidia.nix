{...}: {
  flake.modules.nixos.nvidia = {config, lib, pkgs, ...}:
    lib.mkIf config.dendrix.hasNvidia {
      boot.blacklistedKernelModules = ["nouveau"];
    environment.systemPackages = [
      pkgs.nvtopPackages.full
      pkgs.mesa-demos
      pkgs.vulkan-tools
      pkgs.libva-utils
      pkgs.nvidia-vaapi-driver
    ];

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };

    services.xserver.videoDrivers = ["nvidia"];
    hardware.graphics = {
      enable = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = true;
      open = false;
      nvidiaSettings = true;
    };
  };
}
