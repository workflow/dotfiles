{pkgs, ...}: {
  # Writes to /etc/sysctl.d/60-nixos.conf
  boot.kernel.sysctl = {
    # Enable all magic sysrq commands (NixOS sets this to 16, which enables sync only)
    "kernel.sysrq" = 1;
    "vm.swappiness" = 0;
  };

  boot.kernelPackages = pkgs.linuxPackages_zen; # Optimized for desktop use
  environment.systemPackages = with pkgs; [
    linuxKernel.packages.linux_zen.perf
    linuxKernel.packages.linux_zen.cpupower
  ];
}
