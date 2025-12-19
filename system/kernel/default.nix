{pkgs, ...}: {
  # Writes to /etc/sysctl.d/60-nixos.conf
  boot.kernel.sysctl = {
    # Enable all magic sysrq commands (NixOS sets this to 16, which enables sync only)
    "kernel.sysrq" = 1;
    "vm.swappiness" = 20; # balanced setting favoring RAM usage, Default=60
  };

  boot.kernelPackages = pkgs.linuxPackages_zen; # Optimized for desktop use
  environment.systemPackages = with pkgs; [
    perf
    linuxKernel.packages.linux_zen.cpupower
  ];

  boot.initrd.verbose = true;
  # Keep console visible during teardown
  boot.kernelParams = [
    "systemd.show_status=1"
    "i915.enable_psr=0" # Intel PSR often blanks the console on transitions
    "i915.fastboot=0" # avoid early/quiet KMS handover
  ];
}
