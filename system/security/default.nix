{
  config,
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  environment.persistence."/persist/system" = lib.mkIf isImpermanent {
    directories = [
      "/var/lib/boltd" # Boltd state
      "/run/sudo" # Sudo timestamp (to not show the lecture message)
    ];
  };
  home-manager.users.farlion.home.persistence."/persist" = lib.mkIf config.home-manager.extraSpecialArgs.isImpermanent {
    directories = [
      ".local/share/keyrings" # Gnome Keyrings
      ".gnupg" # PGP keys
    ];
  };

  # Thunderbolt security daemon
  services.hardware.bolt.enable = true;

  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [
    libsecret # Already in home packages but ensuring it's available system-wide
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false; # Let GNOME Keyring handle SSH agent
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  programs.seahorse.enable = true;

  # Writes to /etc/sudoers
  security.sudo.extraConfig = ''
    Defaults:root,%wheel timestamp_timeout=30
  '';
  users.users.farlion.extraGroups = ["wheel"];

  # Yubikeys
  services.pcscd.enable = true; # Smartcard services for Yubikeys
  # Sudo via U2F (Yubikey)
  security.pam = {
    u2f = {
      enable = true;
      control = "sufficient";
      settings = {
        origin = "pam://farlion-realm"; # Overridde host-dependent realm to share yubikey
        appid = "pam://farlion-realm"; # keep equal to origin for compatibility
        cue = false; # CLI message to show touch is needed, not needed since using system-wide notification
      };
    };
    services = {
      login.u2fAuth = false;
      ly.u2fAuth = false;
      sudo.u2fAuth = true;
      swaylock.u2fAuth = true;
    };
  };
  # Enable system-wide Yubikey Support
  services.udev.packages = [pkgs.yubikey-personalization];
}
