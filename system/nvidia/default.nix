{pkgs, ...}: {
  boot.blacklistedKernelModules = ["nouveau"];
  environment.systemPackages = [
    pkgs.nvtopPackages.full # nvtop
  ];
  services.xserver.videoDrivers = ["nvidia"];
}
