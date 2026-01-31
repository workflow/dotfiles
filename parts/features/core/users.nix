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
      hashedPassword = lib.mkDefault "";
      isNormalUser = true;
      shell = pkgs.fish;
    };

    programs.vim = {
      defaultEditor = true;
      enable = true;
    };
    programs.fish.enable = true;
  };
}
