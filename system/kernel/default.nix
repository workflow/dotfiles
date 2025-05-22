{pkgs, ...}: {
  # Writes to /etc/sysctl.d/60-nixos.conf
  boot.kernel.sysctl = {
    # Enable all magic sysrq commands (NixOS sets this to 16, which enables sync only)
    "kernel.sysrq" = 1;
    "vm.swappiness" = 20; # balanced setting favoring RAM usage, Default=60
  };

  # boot.kernelPackages = pkgs.linuxPackages_zen; # Optimized for desktop use
  # Temporary pin to work around NVidia driver issues, see https://github.com/NixOS/nixpkgs/issues/375730#issuecomment-2625234288
  boot.kernelPackages = pkgs.linuxPackages_6_12; # Optimized for desktop use
  environment.systemPackages = with pkgs; [
    linuxKernel.packages.linux_zen.perf
    linuxKernel.packages.linux_zen.cpupower
  ];
}
