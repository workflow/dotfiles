{...}: {
  flake.modules.nixos.video = {pkgs, ...}: {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };

    environment.systemPackages = [pkgs.v4l-utils];

    users.users.farlion.extraGroups = ["video"];
  };
}
