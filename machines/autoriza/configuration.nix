# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.useDHCP = false;
  networking.interfaces.enp60s0u1u1 = {
    name = "enp60s0u1u1";
    ipv4 = {
      addresses = [
        {
          address = "192.168.1.43";
          prefixLength = 24;
        }
      ];
    };
  };
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.hostName = "autoriza";
  services.openssh = {
    enable = true;
    ports = [ 4343 ];
    permitRootLogin = "no";
    passwordAuthentication = false;
  };
  users.users.autoriza.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCyNsCaP1NkguOYELnp9P8XdGECRgx3zWiCZxzqC6GVJlT6Av5W/eDpCW/gnyztXH2KYnDrvIwaZDmDzOYWqQyVqx2AQqnd87MS43G9gOYEY4tPBBjNQE72ngMjTHu8k1NmdNMjEYslD9xuLUrH6QxYmFYdJbBDJXqOnuUE4HjOpBqhRvb9OP5f2MuKQ4fhVyqI60XF/i8fAQ0KRP9ZFc9QWAlWNNBit1zuBzE/vvt03k0vPL3C/U8EwUqvy3UyesH5ZwiXPlzQLb0Kgja7VAn1+jOgTRQKVJFuwm80lJz4dvycXg0g+aHuoRI+8GgE0lsJzCf5KAdP3N73b/d5uMKumE63bjaA9TQtRLN3GupcZjq3uRl3ee78XycUnd+WPG16NbrvBzh7HS1xT/I4LAAxs6nCyzD5G+B9l3Z1rhM5qXXQNwWQ8jlNRKmgSNdTnD+/jAZ1epFsbh9N20TiSe3G22hYv2a6KjKecT7YQgagFe5iKAA/noNkANhsXzarT72bLdsDwzyyKczkHpEKqtUSOBS7tTjAUn64+DJNMda+CGgU0eIJWa/2wKCz4r5qQakP7TWUfppuyJCR+KItciXPss0EuMgZLtD6L+XhcnnD3NuIJ0H/UErhCI7BaWompbkW+bM072Nh6nqueZphkblNBwvKQYpmdGIGT76YV2uDpw== autoriza@boar"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDi3WvLY1pQszFKjlGR1+dbUBIaYCLWv12q13E7tsHJMF32US6bMRDTxnoxTO1bJ7X7RTHcvGki154expBSkrD/K/DUVV2LTkqnBAk5QRgvFg0LWz4m13HDfr4DxhSvK2z1ZYUavGJY8t+R8bfGPTTnqLzmHhnhXLuL5X0rn0oDrBy2cmYsWYcUbe0jfjQCv+JyvvvnxjEuJPWS1w+R5vFsKzaA8/IusHWaIhycIOXjfpKysACCTSnVsacEWgp0hMiNNTPuhkUGMg6i8J34fF8JkveChYMp5gOnQVCYZj3xzVP7leAPrCTyp8X1od86K+ER/qUOHIMS60fQSc/s2o1 autoriza@nutyone"
  ];

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "autoriza";
      };
      sddm = {
        enable = true;
      };
    };
    windowManager.i3 = {
      enable = true;
    };
    monitorSection =
      ''
        Option         "DPMS" "true"
      '';
    serverFlagsSection =
      ''
        Option "BlankTime" "5"
        Option "StandbyTime" "5"
        Option "SuspendTime" "5"
        Option "OffTime" "5"
      '';
  };

  # Power management
  services.logind = {
    extraConfig = ''
      HandleLidSwitch=ignore
      HandleLidSwitchExternalPower=ignore
      HandleLidSwitchDocked=ignore
    '';
  };

  programs.neovim.enable = true;
  programs.neovim.vimAlias = true;
  programs.neovim.viAlias = true;




  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Set up NixOS such that TurboVNC's built-in software OpenGL implementation works
  programs.turbovnc.ensureHeadlessSoftwareOpenGL = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.autoriza = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      direnv
      firefox
      git
      github-cli
      killall
      tree
      neovim
      x11vnc
      xclip
      xdotool
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

