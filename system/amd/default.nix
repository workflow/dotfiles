{pkgs, ...}: {
  boot.initrd.kernelModules = ["amdgpu"];
  environment.systemPackages = [
    pkgs.mesa-demos
    pkgs.nvtopPackages.full # nvtop
    pkgs.vulkan-tools
  ];
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # AMDVLK drivers (programs will choose whether to use this over Mesa RADV drivers)
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];
  # For 32 bit applications
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
}
