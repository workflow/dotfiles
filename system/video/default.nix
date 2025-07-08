{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };

  environment.systemPackages = [
    pkgs.v4l-utils # Video4Linux2 -> configuring webcam
  ];

  users.users.farlion.extraGroups = ["video"];
}
