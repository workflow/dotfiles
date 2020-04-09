{ pkgs, lib, ... }:

let

  i3lock-wrap = pkgs.callPackage ../../packages/tools/i3lock-wrap {};
  lock-cmd = "${i3lock-wrap}/bin/i3lock-wrap";

in
{
  # lock after 10 minutes
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

}
