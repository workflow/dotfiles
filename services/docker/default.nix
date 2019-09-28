{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # this will add "docker" to the existing user groups
  users.users.alex.extraGroups = [ "docker" ];

  environment.systemPackages = [
    pkgs.docker-compose
  ];
}
