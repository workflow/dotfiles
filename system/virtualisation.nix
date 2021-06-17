{ pkgs, ... }:
{

  virtualisation.docker.enable = true;

  virtualisation.libvirtd.enable = true;
  # Forward USB devices from unprivileged user for use by Spice USB Forwarding (via virt-manager)
  security.wrappers.spice-client-glib-usb-acl-helper.source = "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";

  # TODO: This is insecure
  # See https://nixos.wiki/wiki/Docker
  users.users.farlion.extraGroups = [ "docker" "libvirtd" "kvm" ];

}
