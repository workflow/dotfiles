{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  environment.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      "/home/farlion/.local/share/keyrings" # Gnome Keyrings
      "/var/lib/boltd" # Boltd state
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

  boot.loader.systemd-boot.editor = false;

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
