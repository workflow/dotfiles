{pkgs, ...}: let
  xsession-name = "i3";
in {
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "farlion";

    defaultSession = xsession-name;
  };

  services.xserver = {
    enable = true;

    displayManager = {
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

  programs.seahorse.enable = true;
}
