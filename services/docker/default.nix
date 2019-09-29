{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  environment.systemPackages = [ pkgs.docker-compose ];
}
