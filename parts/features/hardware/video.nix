{...}: {
  flake.modules.nixos.video = {
    config,
    lib,
    pkgs,
    ...
  }: let
    isNumenor = config.dendrix.hostname == "numenor";
    v4l2loopback = config.boot.kernelPackages.v4l2loopback;
    obsCamNr = 1;
    # Must match OBS's output resolution/FPS: set-caps enables keep_format, locking it in.
    obsCamCaps = "YUYV:1920x1080@30/1";
  in {
    programs.obs-studio.enable = true;

    # Manual virtual camera setup instead of programs.obs-studio.enableVirtualCamera:
    # that option hardcodes exclusive_caps=1, which hides the capture caps until OBS
    # feeds the device. WirePlumber probes at login (before OBS), never re-probes, and
    # so never creates the PipeWire camera node that Chromium-based browsers enumerate.
    boot = {
      kernelModules = ["v4l2loopback"];
      extraModulePackages = [v4l2loopback];
      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=${toString obsCamNr} card_label="OBS Cam" exclusive_caps=0
      '';
    };

    # Unfed, the device advertises every format as 2x1..8192x8192 ranges; that is
    # what WirePlumber's one-time probe captures, and libwebrtc (Brave's PipeWire
    # camera) parses no capabilities from it, so it drops OBS Cam. Pinning the
    # caps before any user session starts yields one fixed, parseable format.
    systemd.services.obs-cam-caps = {
      description = "Pin OBS Cam v4l2loopback format";
      after = ["systemd-modules-load.service"];
      before = ["systemd-user-sessions.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${v4l2loopback.bin}/bin/v4l2loopback-ctl set-caps /dev/video${toString obsCamNr} ${obsCamCaps}";
      };
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
