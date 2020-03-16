{ pkgs, ... }:

let ghc = pkgs.callPackage ../packages/haskell/ghc.nix { };

in {

  environment = {
    extraInit = ''
      export PATH=$HOME/.local/bin:$PATH
    '';
    shellAliases = {
      detach = "udisksctl power-off -b";
      rmpyc = "find . | grep -E '(__pycache__|.pyc|.pyo$)' | xargs rm -rf";
    };
    etc."ipsec.secrets".text = ''
      include ipsec.d/ipsec.nm-l2tp.secrets
    '';
    variables = {
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    };
  };

  users.users.alex = {
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" ];
    shell = pkgs.zsh;
    symlinks = {
      ".vimrc" = pkgs.callPackage ../packages/tools/vim/vimrc.nix { };
      ".gitconfig" = pkgs.callPackage ../packages/tools/git/gitconfig.nix { };
      ".ghci" = pkgs.callPackage ../packages/haskell/scripts/ghci.nix { };
    };
  };

  time.timeZone = "Europe/London";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [{
    name = "root";
    device = "/dev/sda2";
    preLVM = true;
  }];

  boot.supportedFilesystems = [ "ntfs" ];

  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  #networking.firewall.allowedTCPPorts = [ 80 ];

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
