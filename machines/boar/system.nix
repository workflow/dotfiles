{ config, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    memtest86.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = false; # Disable this after first installation to not wear out EFI storage

  # External monitors brightness control
  # See https://discourse.nixos.org/t/brightness-control-of-external-monitors-with-ddcci-backlight/8639/11
  boot.extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];
  security.sudo.extraRules = [
    { users = [ "farlion" ]; commands = [{ command = "/home/farlion/code/nixos-config/home/xsession/boar_ddc_fix.sh"; options = [ "NOPASSWD" "SETENV" ]; }]; }
  ];

  # Plenty of RAM so...
  boot.tmp.useTmpfs = true;

  # GPU
  services.xserver.videoDrivers = [ "nvidia" ];

  # LVM on LUKS
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/69615b0a-fffd-4424-99e6-e39f11dab27e";
      preLVM = true;
    };
    data-b-enc = {
      device = "/dev/disk/by-uuid/3c852f71-6ae8-4c1f-86ff-19ca0d18d33a";
      preLVM = true;
    };
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  networking.hostName = "boar";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
