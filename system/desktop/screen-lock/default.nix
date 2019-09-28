{ pkgs, ... }:

{

  # lock after 10 minutes
  services.xserver.xautolock = {
    enable = true;
    nowlocker = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    locker = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    time = 10;
  };

  # lock on laptop lid close
  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
  };
}
