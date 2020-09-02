{ pkgs, ... }:
{

  virtualisation.docker.enable = true;

  virtualisation.libvirtd.enable = true;

  # TODO: This is insecure
  # See https://nixos.wiki/wiki/Docker
  users.users.farlion.extraGroups = [ "docker" "libvirtd" ];

}
