{pkgs, ...}: let
  xsession-name = "i3";
in {
  services.displayManager = {
    defaultSession = xsession-name;
    ly = {
      enable = true;
      settings = {
        animation = "doom";
        hide_borders = true;
        tty = 9; # Hopefully less logs flowing into the login screen, see https://codeberg.org/AnErrupTion/ly/issues/537
      };
    };
  };

  services.xserver = {
    enable = true;

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
