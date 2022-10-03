{ config, lib, pkgs, ... }:

{
  boot.cleanTmpDir = true;

  # Writes to /etc/sysctl.d/60-nixos.conf
  boot.kernel.sysctl = {
    # Enable all magic sysrq commands (NixOS sets this to 16, which enables sync only)
    "kernel.sysrq" = 1;

    "vm.swappiness" = 0;
  };

  # https://github.com/NixOS/nixpkgs/issues/64965
  environment = {
    etc."ipsec.secrets".text = ''
      include ipsec.d/ipsec.nm-l2tp.secrets
    '';
  };

  # Default SSD Optimizations
  fileSystems."/".options = [ "noatime" "nodiratime" ];

  users = {
    users.farlion = {
      description = "Florian Peter";
      extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" "adbusers" ];
      isNormalUser = true;
      group = "users";
      shell = pkgs.fish;
    };
  };

  time.timeZone = "Europe/Lisbon";
  # services.tzupdate.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  services.blueman.enable = true;
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
  hardware.bluetooth.enable = true;
  services.logind.lidSwitch = "lock";

  services.hardware.bolt.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.hplip
  ];

  # limit the amount of logs stored in /var/log/journal
  # writes to /etc/systemd/journald.conf
  services.journald.extraConfig = ''
    SystemMaxUse=2G
  '';

  # Default editor for root
  programs.vim.defaultEditor = true;

  # Enable system-wide Yubikey Support
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # Autorandr service
  services.autorandr = {
    enable = true;
    defaultTarget = if (config.networking.hostName == "boar") then "boar" else "sophia";
  };

  # Sysdig + kernel module
  programs.sysdig.enable = true;
}
