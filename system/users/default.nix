{pkgs, ...}: {
  users.mutableUsers = false;

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
