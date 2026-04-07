{...}: {
  flake.modules.nixos.video = {
    config,
    lib,
    pkgs,
    ...
  }: let
    isNumenor = config.dendrix.hostname == "numenor";
  in {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };

    environment.systemPackages = [
      pkgs.v4l-utils # Video4Linux2 -> configuring webcam
    ];

    # Stable symlinks for webcams so OBS scenes always get the right camera
    services.udev.extraRules = lib.mkIf isNumenor ''
      SUBSYSTEM=="video4linux", ATTR{index}=="0", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="0e03", SYMLINK+="video-razer-kiyo"
      SUBSYSTEM=="video4linux", ATTR{index}=="0", ATTRS{idVendor}=="2e1a", ATTRS{idProduct}=="4c03", SYMLINK+="video-insta360-link"
    '';

    users.users.farlion.extraGroups = ["video"];
  };
}
