{ lib, config, pkgs, ... }:
let
  isBoar = config.networking.hostName == "boar";
  isFlexbox = config.networking.hostName == "flexbox";
in
{

  # TODO: Give this another shot on 20.09 with offload mode

  # Enable ForceFullCompositionPipeline, to use the NVIDIA compositor over picom
  # See: https://github.com/chjj/compton/issues/227
  #services.xserver.screenSection = ''Option "metamodes" "nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"'';

  #services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  #hardware.nvidia.optimus_prime = {
  #  enable = true;

  #  # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
  #  nvidiaBusId = "PCI:1:0:0";

  #  # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
  #  intelBusId = "PCI:0:2:0";
  #};

  services.xserver.videoDrivers = lib.mkIf (isBoar || isFlexbox) [ "nvidia" ];

}
