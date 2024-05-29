{config, ...}:
{
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
}


