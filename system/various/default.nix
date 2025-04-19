{pkgs, ...}: {
  services.atd.enable = true;

  boot.tmp.cleanOnBoot = true;

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

  boot.supportedFilesystems = ["ntfs"];

  users = {
    users.farlion = {
      description = "Florian Peter";
      extraGroups = ["video" "disk"];
      isNormalUser = true;
      group = "users";
      shell = pkgs.fish;
    };
  };

  services.tzupdate.enable = true; # Oneshot systemd service, run with `sudo systemctl start tzupdate`
  i18n.defaultLocale = "en_US.UTF-8";

  services.blueman.enable = true;
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
  hardware.bluetooth.enable = true;

  services.hardware.bolt.enable = true;

  # limit the amount of logs stored in /var/log/journal
  # writes to /etc/systemd/journald.conf
  services.journald.extraConfig = ''
    SystemMaxUse=2G
  '';

  # Default editor for root
  programs.vim = {
    defaultEditor = true;
    enable = true;
  };

  # Enable system-wide Yubikey Support
  services.udev.packages = [pkgs.yubikey-personalization];

  programs.fish.enable = true;
}
