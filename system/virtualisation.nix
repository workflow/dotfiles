{ pkgs, ... }:
{

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # https://rootlesscontaine.rs/getting-started/common/cgroup2/#enabling-cpu-cpuset-and-io-delegation
  # For minikube
  # Writes to /etc/systemd/system/user@.service.d/overrides.conf
  systemd.services."user@".serviceConfig = {
    Delegate = "cpu cpuset io memory pids";
  };

  virtualisation.libvirtd.enable = true;

  virtualisation.podman = {
    enable = true;
  };

  users.users.farlion.extraGroups = [ "libvirtd" "kvm" ];

}
