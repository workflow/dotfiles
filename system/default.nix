{ pkgs, ... }:

{

  environment.extraInit = ''
    export PATH=$HOME/.local/bin:$PATH
  '';

  time.timeZone = "Europe/London";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [{
    name = "root";
    device = "/dev/sda2";
    preLVM = true;
  }];

  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.devmon.enable = true;

  # to prevent nix-shell complaining about no space left
  # default value is 10% of total RAM
  services.logind.extraConfig = ''
    RuntimeDirectorySize=4G
  '';

}
