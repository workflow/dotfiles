{ pkgs, ... }:
{
  boot.loader.systemd-boot.editor = false;

  # Writes to /etc/sudoers
  security.sudo.extraConfig = ''
    Defaults:root,%wheel timestamp_timeout=30
  '';

  security.sudo.extraRules = [
    {
      users = [ "farlion" ];
      commands = [
        { command = "${pkgs.tailscale}/bin/tailscale up --accept-routes --accept-dns=false"; options = [ "NOPASSWD" "SETENV" ]; }
        { command = "${pkgs.tailscale}/bin/tailscale down"; options = [ "NOPASSWD" "SETENV" ]; }
        { command = "/run/current-system/sw/bin/systemctl start macgyver"; options = [ "NOPASSWD" "SETENV" ]; }
        { command = "/run/current-system/sw/bin/systemctl stop macgyver"; options = [ "NOPASSWD" "SETENV" ]; }
      ];
    }
  ];

  services.fwupd.enable = true;

  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
  };
}
