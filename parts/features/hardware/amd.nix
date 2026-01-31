{...}: {
  flake.modules.nixos.amd = {pkgs, ...}: {
    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };

    boot.kernelParams = [
      "amdgpu.runpm=0"
    ];

    environment.systemPackages = with pkgs; [
      lact
      libva-utils
      mesa-demos
      nvtopPackages.full
      vulkan-tools
    ];
    services.xserver.videoDrivers = ["amdgpu"];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    systemd.packages = with pkgs; [lact];
    systemd.services.lactd.wantedBy = ["multi-user.target"];
  };
}
