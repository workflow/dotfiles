{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  environment.persistence."/persist" = lib.mkIf isImpermanent {
    files = [
      "/etc/group"
      "/etc/passwd"
      "/etc/shadow"
      "/etc/gshadow"
    ];
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
