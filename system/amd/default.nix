# See: https://wiki.nixos.org/wiki/AMD_GPU
# Also see: https://wiki.archlinux.org/title/Hardware_video_acceleration
{pkgs, ...}: {
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
    amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    lact # GUI for overclocking, undervolting, setting fan curves, etc.
    libva-utils
    mesa-demos
    nvtopPackages.full # nvtop
    vulkan-tools
  ];
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # # AMDVLK drivers (programs will choose whether to use this over Mesa RADV drivers)
  # hardware.graphics.extraPackages = with pkgs; [
  #   amdvlk
  # ];
  # # For 32 bit applications
  # hardware.opengl.extraPackages32 = with pkgs; [
  #   driversi686Linux.amdvlk
  # ];

  # GUI for overclocking, undervolting, setting fan curves, etc.
  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];
}
