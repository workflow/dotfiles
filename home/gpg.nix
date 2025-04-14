{pkgs, ...}: {
  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets" "ssh"];
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    grabKeyboardAndMouse = false;
    pinentryPackage = pkgs.pinentry-tty;
  };
}
