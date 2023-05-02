{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    grabKeyboardAndMouse = false;
  };

}
