{...}: {
  virtualisation.docker = {
    enable = true;
    # daemon.settings = {
    # Attach to resolved instead of using default servers
    # dns = ["172.17.0.1"];
    # };
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
