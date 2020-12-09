{ pkgs, lib, ... }:
let

  xsession-name = "i3";

in
{

  services.xserver = {
    enable = true;

    # Touchpad
    libinput = {
      enable = true;
      disableWhileTyping = true;
    };

    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "farlion";
      defaultSession = xsession-name;

      lightdm = {
        enable = true;
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

}
