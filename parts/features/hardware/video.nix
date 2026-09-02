{...}: {
  flake.modules.nixos.video = {
    config,
    lib,
    pkgs,
    ...
  }: let
    isNumenor = config.dendrix.hostname == "numenor";
  in {
    programs.obs-studio.enable = true;

    # Manual virtual camera setup instead of programs.obs-studio.enableVirtualCamera:
    # that option hardcodes exclusive_caps=1, which hides the capture caps until OBS
    # feeds the device. WirePlumber probes at login (before OBS), never re-probes, and
    # so never creates the PipeWire camera node that Chromium-based browsers enumerate.
    boot = {
      kernelModules = ["v4l2loopback"];
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=0
      '';
    };

    security.polkit.enable = true;

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
