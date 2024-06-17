{pkgs, ...}: {
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    grabKeyboardAndMouse = false;
    pinentryPackage = pkgs.pinentry-tty;
  };
}
