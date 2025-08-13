{
  lib,
  isImpermanent,
  pkgs,
  ...
}: let
  ssh-add-all = pkgs.writeShellApplication {
    name = "ssh-add-all";
    runtimeInputs = with pkgs; [openssh coreutils];
    text = builtins.readFile ./ssh-add-all.sh;
  };
in {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".ssh"
    ];
  };

  home.packages = [ssh-add-all];

  programs.ssh = {
    enable = true;
    extraConfig = ''
      PubkeyAcceptedKeyTypes +ssh-rsa
      HostKeyAlgorithms +ssh-rsa
      AddKeysToAgent yes
    '';
  };

  # Enable SSH agent integration with GNOME Keyring
  services.ssh-agent = {
    enable = false; # Disable default ssh-agent since we'll use gnome-keyring
  };

  # Set up environment variables for SSH agent
  home.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
  };

  # Start GNOME Keyring SSH agent
  systemd.user.services.gnome-keyring-ssh = {
    Unit = {
      Description = "GNOME Keyring SSH Agent";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Type = "forking";
      ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=ssh";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
