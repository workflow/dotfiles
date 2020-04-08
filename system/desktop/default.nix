{ pkgs, lib, ... }:

let

  sources = import ../../nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable {};

in

{
  imports = [ ./screen-lock.nix ];

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

  environment.systemPackages =
    [
      pkgs.xfce.dconf
      pkgs.xfce.xfconf
      pkgs.xfce.xfce4-battery-plugin
      pkgs.xfce.xfce4-xkb-plugin
      pkgs.xfce.xfce4-systemload-plugin
      pkgs.adapta-gtk-theme
      nixpkgs-unstable.vimix-gtk-themes
    ];

}
