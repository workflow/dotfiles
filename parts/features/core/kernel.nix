{...}: {
  flake.modules.nixos.kernel = {pkgs, ...}: {
    boot.kernel.sysctl = {
      "kernel.sysrq" = 1;
      "vm.swappiness" = 20;
    };

    boot.kernelPackages = pkgs.linuxPackages_zen;
    environment.systemPackages = with pkgs; [
      perf
      linuxKernel.packages.linux_zen.cpupower
    ];

    boot.initrd.verbose = true;
    boot.kernelParams = [
      "systemd.show_status=1"
      "i915.enable_psr=0"
      "i915.fastboot=0"
    ];
  };
}
