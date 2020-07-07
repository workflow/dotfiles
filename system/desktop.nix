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

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu # Application launcher most people use
        i3status # Gives you the default i3 status bar
        i3lock # Default i3 screen locker
        i3blocks # If you are planning on using i3blocks over i3status
      ];
    };

  };

  # I3 on KDE Plasma
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  environment.systemPackages = [];

}
