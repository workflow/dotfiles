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
  # Forward USB devices from unprivileged user for use by Spice USB Forwarding (via virt-manager)
  # TODO: The security.wrappers option now requires to always specify an owner, group and whether the setuid/setgid bit should be set. This is motivated by the fact that before NixOS 21.11, specifying either setuid or setgid but not owner/group resulted in wrappers owned by nobody/nogroup, which is unsafe.
  #security.wrappers.spice-client-glib-usb-acl-helper.source = "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";

  users.users.farlion.extraGroups = [ "libvirtd" "kvm" ];

}
