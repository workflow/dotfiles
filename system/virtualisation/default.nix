{
  config,
  isImpermanent,
  lib,
  pkgs,
  ...
}: let
  isFlexbox = config.networking.hostName == "flexbox";
  isBoar = config.networking.hostName == "boar";
in {
  environment.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      "/var/lib/containers" # Podman
      "/var/lib/docker"
      "/var/lib/libvirt" # Virt-Manager
    ];
  };

  environment.systemPackages = [
    pkgs.virt-manager # Desktop user interface for managing virtual machines
  ];
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      # Attach to resolved instead of using default Docker DNS servers
      dns = ["172.17.0.1"];
      # Have containers listen on localhost instead of 0.0.0.0,
      # see https://github.com/NixOS/nixpkgs/issues/111852#issuecomment-1954656069
      ip = "127.0.0.1";
    };
  };
  # Allow connecting to resolved DNS from inside Docker containers
  networking.firewall.interfaces.docker0.allowedTCPPorts = [53];
  networking.firewall.interfaces.docker0.allowedUDPPorts = [53];
  # Kind
  networking.firewall.interfaces.br-19583dda413b = lib.mkIf isFlexbox {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };
  networking.firewall.interfaces.br-5e5007921f27 = lib.mkIf isBoar {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };
  # Ad-hoc (Docker Compose)
  networking.firewall.interfaces.br-1a132ab74d09 = lib.mkIf isBoar {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };

  # https://rootlesscontaine.rs/getting-started/common/cgroup2/#enabling-cpu-cpuset-and-io-delegation
  # For minikube
  # Writes to /etc/systemd/system/user@.service.d/overrides.conf
  # systemd.services."user@".serviceConfig = {
  #   Delegate = "cpu cpuset io memory pids";
  # };

  virtualisation.libvirtd.enable = true;

  virtualisation.podman = {
    enable = true;
  };

  users.users.farlion.extraGroups = ["libvirtd" "kvm" "docker"];
}
