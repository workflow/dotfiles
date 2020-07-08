{ pkgs, lib, ... }:

let

  #indicator-redshift = pkgs.callPackage ../packages/tools/indicator-redshift {};

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
      defaultSession = "plasma5+i3";

      lightdm = {
        enable = true;
        autoLogin.enable = true;
        autoLogin.user = "farlion";
      };
    };

    desktopManager = {
      plasma5.enable = true;
      # Delegate xsession to home-manager
      # See https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/8 
      session = [
        {
          name = "home-manager";
          start = ''
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
            waitPID=$!
          '';
        }
      ];
    };

    windowManager = {
      i3.enable = true;
    };

  };

  # I3 on KDE Plasma
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  environment.systemPackages = [];

}
