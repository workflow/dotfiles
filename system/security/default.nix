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
  home-manager.users.farlion.home.persistence."/persist/home/farlion" = lib.mkIf config.home-manager.extraSpecialArgs.isImpermanent {
    directories = [
      ".local/share/keyrings" # Gnome Keyrings
      ".gnupg" # PGP keys
    ];
  };

  # Thunderbolt security daemon
  services.hardware.bolt.enable = true;

  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [
    # TODO: still needed?
    gcr # Gnome crypto services for gnome-keyring
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  programs.seahorse.enable = true;

  # Writes to /etc/sudoers
  security.sudo.extraConfig = ''
    Defaults:root,%wheel timestamp_timeout=30
  '';
  users.users.farlion.extraGroups = ["wheel"];

  # Yubikeys
  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
  };
  # Enable system-wide Yubikey Support
  services.udev.packages = [pkgs.yubikey-personalization];
}
