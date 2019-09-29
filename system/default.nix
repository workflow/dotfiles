{ pkgs, ... }:

{

  environment = {
    extraInit = ''
      export PATH=$HOME/.local/bin:$PATH
    '';
    shellAliases = {
      detach = "udisksctl power-off -b";
      rmpyc = "find . | grep -E '(__pycache__|.pyc|.pyo$)' | xargs rm -rf";
    };
  };

  users.users.alex = {
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" ];
    shell = pkgs.zsh;
    symlinks = {
      ".vimrc" = pkgs.callPackage ../packages/apps/vim/vimrc.nix { };
      ".gitconfig" = pkgs.callPackage ../packages/git { };
      ".ghci" = pkgs.callPackage ../packages/dev/haskell/scripts/ghci.nix { };
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
