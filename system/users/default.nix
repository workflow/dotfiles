{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  environment.persistence."/persist/system" = lib.mkIf isImpermanent {
    files = [
      "/etc/group"
      "/etc/passwd"
      "/etc/shadow"
    ];
  };
  # These three files create timing errors for some reason with impermanence, mounting them like this helps
  environment.etc = lib.mkIf isImpermanent {
    "group".source = "/persist/system/etc/group";
    "passwd".source = "/persist/system/etc/passwd";
    "shadow".source = "/persist/system/etc/shadow";
  };

  users = {
    users.farlion = {
      description = "Florian Peter";
      extraGroups = ["disk"];
      isNormalUser = true;
      group = "users";
      shell = pkgs.fish;
    };
  };

  # Default editor for root
  programs.vim = {
    defaultEditor = true;
    enable = true;
  };
  # Enable fish for root
  programs.fish.enable = true;
}
