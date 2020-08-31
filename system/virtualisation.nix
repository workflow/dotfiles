{ pkgs, ... }:
{

  virtualisation.docker.enable = true;

  # TODO: This is insecure
  # See https://nixos.wiki/wiki/Docker
  users.users.farlion.extraGroups = [ "docker" ];

}
