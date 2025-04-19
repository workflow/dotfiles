{
  lib,
  isImpermanent,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".ssh"
    ];
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      PubkeyAcceptedKeyTypes +ssh-rsa
      HostKeyAlgorithms +ssh-rsa
    '';
  };
}
