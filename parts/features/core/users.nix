{...}: {
  flake.modules.nixos.users = {
    lib,
    pkgs,
    ...
  }: {
    users.mutableUsers = false;

    users.users.farlion = {
      description = "Florian Peter";
      extraGroups = ["disk"];
      group = "users";
      hashedPassword = lib.mkDefault ""; # For CI, otherwise gets overwritten by parent `secrets` flake
      isNormalUser = true;
      shell = pkgs.fish;
    };

    # Default editor for root
    programs.vim = {
      defaultEditor = true;
      enable = true;
    };
    # Enable fish for root
    programs.fish.enable = true;
  };
}
