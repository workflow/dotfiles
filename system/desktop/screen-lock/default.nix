{ pkgs, ... }:

let

  lock-cmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -p";

in

{
  # lock after 10 minutes
  services.xserver.xautolock = {
    enable = true;
    nowlocker = lock-cmd;
    locker = lock-cmd;
    time = 10;
  };

  # lock on laptop lid close
  programs.xss-lock = {
    enable = true;
    lockerCommand = lock-cmd;
  };
}
