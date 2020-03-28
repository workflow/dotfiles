{ pkgs, lib, ... }:

{
  imports = [ ./screen-lock ];

  # services.gnome3.gnome-terminal-server.enable = true;
  programs.gnome-terminal.enable = true;

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
          (sleep 6 && xset dpms 0 0 600) &
          ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
          ~/projects/indicators/indicator-charge/run-indicator &
          ~/projects/indicators/indicator-redshift/run-indicator &
          ${pkgs.dropbox}/bin/dropbox &
        '';
      };
    };

    windowManager = {
      default = "xmonad";
      xmonad = {
        enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs.xfce;
    [ xfce4-battery-plugin xfce4-xkb-plugin xfce4-systemload-plugin ];

}
