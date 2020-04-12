{ pkgs, ... }:

{
  environment = {
    etc."ipsec.secrets".text = ''
      include ipsec.d/ipsec.nm-l2tp.secrets
    '';
  };

  programs.fish.enable = true; # to add entry in /etc/shells

  users = {
    users.alex = {
      extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" ];
      isNormalUser = true;
      shell = pkgs.fish;
    };
    defaultUserShell = pkgs.bash;
  };

  time.timeZone = "Europe/London";

  boot.supportedFilesystems = [ "ntfs" ];

  networking.networkmanager.enable = true;
  networking.hostName = "seabeast";
  #networking.firewall.allowedTCPPorts = [ 80 ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.devmon.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.hplip
  ];

  services.keybase.enable = true;
  services.kbfs.enable = true;

  # to prevent nix-shell complaining about no space left
  # default value is 10% of total RAM
  services.logind.extraConfig = ''
    RuntimeDirectorySize=4G
  '';

}
