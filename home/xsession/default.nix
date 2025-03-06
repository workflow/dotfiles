{pkgs, ...}: {
  home.file = {
    "bin/caffeinate" = {
      source = ./caffeinate.sh;
      executable = true;
    };
    "bin/decaffeinate" = {
      source = ./decaffeinate.sh;
      executable = true;
    };
  };

  xsession = {
    enable = true;
    initExtra = ''
      # Needed for things like seahorse/gnome-keyring to find the correct display
      ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY
    '';
    profileExtra = ''
      eval $(${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --daemonize --components=secrets,ssh,pkcs11)
      export SSH_AUTH_SOCK
    '';
    scriptPath = ".hm-xsession"; # Ref: https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/8
  };
}
