{config, pkgs, ...}:
{
  # Loopback video device :)
  # exclusive_caps=1 is needed for Chrome/WebRTC apps to be able to see the virtual cam
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=7 card_label="OBS Cam" exclusive_caps=1
  '';
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];

  environment.systemPackages = [
      pkgs.nvtopPackages.full # nvtop
      pkgs.v4l-utils # Video4Linux2 -> configuring webcam
  ];

}


