{ pkgs, lib, ... }:

let

  indicator-redshift = pkgs.callPackage ../packages/tools/indicator-redshift {};
  indicator-tpacpi = pkgs.callPackage ../packages/tools/indicator-tpacpi {};

  i3lock-wrap = pkgs.callPackage ../packages/tools/i3lock-wrap {};
  lock-cmd = "${i3lock-wrap}/bin/i3lock-wrap";

  trayer-wrap = pkgs.callPackage ../packages/tools/trayer-wrap.nix {};

in

{
  # services.gnome3.gnome-terminal-server.enable = true;
  programs.gnome-terminal.enable = true;

  services.xserver = {
    enable = true;

    libinput = {
      enable = true;
      naturalScrolling = true;
    };

    displayManager = {
      gdm = {
        enable = true;
        wayland = false;
      };
      sddm.enable = lib.mkForce false;
      defaultSession = "none+xmonad";
      sessionCommands = ''
        (sleep 6 && xset dpms 0 0 600) &
        ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${indicator-tpacpi}/bin/indicator-tpacpi &
        ${indicator-redshift}/bin/indicator-redshift &
        ${pkgs.dropbox}/bin/dropbox &
        ${pkgs.networkmanagerapplet}/bin/nm-applet &
        ${trayer-wrap}/bin/trayer-wrap &
        ${pkgs.dunst}/bin/dunst &
        ${pkgs.feh}/bin/feh --bg-max ${../assets/wallpaper.png}
      '';
    };

    desktopManager = {
      plasma5.enable = lib.mkForce false;
      xfce = {
        enable = true;
        noDesktop = false;
        enableXfwm = false;
      };
    };

    windowManager = {
      xmonad = {
        enable = true;
      };
    };
  };

  # lock screen after 10 minutes
  services.xserver.xautolock = {
    enable = true;
    nowlocker = lock-cmd;
    locker = lock-cmd;
    time = 10;
    extraOptions = [ "-corners" "0--0" "-cornersize" "30" ];
  };
  systemd.user.services.xautolock.serviceConfig.Restart = lib.mkForce "always";

  # lock on laptop lid close
  programs.xss-lock = {
    enable = true;
    lockerCommand = lock-cmd;
  };
  systemd.user.services.xss-lock.serviceConfig.Restart = lib.mkForce "always";

  environment.systemPackages =
    [
      pkgs.xfce.dconf
      pkgs.xfce.xfconf
      pkgs.xfce.xfce4-battery-plugin
      pkgs.xfce.xfce4-xkb-plugin
      pkgs.xfce.xfce4-systemload-plugin
      pkgs.xfce.xfce4-cpugraph-plugin
    ];

}
