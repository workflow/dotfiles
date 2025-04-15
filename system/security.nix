{pkgs, ...}: {
  services.gnome.gnome-keyring.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  boot.loader.systemd-boot.editor = false;

  # Writes to /etc/sudoers
  security.sudo.extraConfig = ''
    Defaults:root,%wheel timestamp_timeout=30
  '';

  services.trezord.enable = true;

  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
  };
}
