{ pkgs, lib, ... }:

{
  services.gnome3.gnome-terminal-server.enable = true;

  services.xserver = {
    enable = true;

    libinput = {
      enable = true;
      naturalScrolling = true;
    };

    displayManager = {
      gdm.enable = true;
      sddm.enable = lib.mkForce false;
    };

    desktopManager = {
      default = "xfce";
      plasma5.enable = lib.mkForce false;
      xfce = {
        enable = true;
        noDesktop = false;
        enableXfwm = false;
        extraSessionCommands = ''
          (sleep 6 && xset r rate 500 45) &
          xscreensaver -nosplash &
          ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
        '';
      };
    };

    windowManager = {
      default = "xmonad";
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
        ];
      };
    };
  };

  services.acpid = {
    enable = true;
    logEvents = true;
  };

}
