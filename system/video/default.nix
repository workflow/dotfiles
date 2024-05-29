{config, pkgs, ...}:
{
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];

  environment.systemPackages = [
      pkgs.v4l-utils # Video4Linux2 -> configuring webcam
  ];

}


