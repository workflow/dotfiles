{pkgs, ...}: {
  boot.blacklistedKernelModules = ["nouveau"];
}
