{
  config,
  pkgs,
  ...
}: {
  # Loopback video device :)
  # exclusive_caps=1 is needed for Chrome/WebRTC apps to be able to see the virtual cam
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=7 card_label="OBS Cam" exclusive_caps=1
  '';
  # OBS virtual cam fix until OBS 31.1 is released
  boot.extraModulePackages = [
    (pkgs.linuxPackages_zen.v4l2loopback.overrideAttrs (_: {
      version = "0.13.2-manual";
      src = pkgs.fetchFromGitHub {
        owner = "umlaeute";
        repo = "v4l2loopback";
        rev = "v0.13.2";
        hash = "sha256-rcwgOXnhRPTmNKUppupfe/2qNUBDUqVb3TeDbrP5pnU=";
      };
    }))
  ];
  # TODO: Once fixed, consider using NixOS programs.obs-studio.enableVirtualCamera instead
  # boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
  boot.kernelModules = ["v4l2loopback"];

  environment.systemPackages = [
    pkgs.v4l-utils # Video4Linux2 -> configuring webcam
  ];

  users.users.farlion.extraGroups = ["video"];
}
