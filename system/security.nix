{...}: {
  # Gnome Keyring
  services.gnome.gnome-keyring.enable = true;

  boot.loader.systemd-boot.editor = false;

  # Writes to /etc/sudoers
  security.sudo.extraConfig = ''
    Defaults:root,%wheel timestamp_timeout=30
  '';

  services.fwupd.enable = true;

  services.trezord.enable = true;

  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
  };
}
