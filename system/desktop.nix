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
