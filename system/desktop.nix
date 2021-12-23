{ pkgs, lib, ... }:
let

  xsession-name = "i3";

in
{

  services.xserver = {
    enable = true;

    # Writes to /etc/X11/xorg.conf.d
    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
    };

    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "farlion";
      defaultSession = xsession-name;

      lightdm = {
        enable = true;
        greeter.enable = false;
      };
    };

    desktopManager = {
      # Delegate xsession to home-manager
      # See https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/8
      session = [
        {
          name = xsession-name;
          start = ''
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
            waitPID=$!
          '';
        }
      ];
    };

    windowManager = {
      i3 = {
        enable = true;
      };
    };

  };

  environment.systemPackages = [ ];

  programs.seahorse.enable = true;

}
