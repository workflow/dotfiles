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

  xsession.profileExtra = ''
    eval $(${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --daemonize --components=secrets,ssh,pkcs11)
    export SSH_AUTH_SOCK
  '';

  xsession.enable = true;
  xsession.scriptPath = ".hm-xsession"; # Ref: https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/8
}
