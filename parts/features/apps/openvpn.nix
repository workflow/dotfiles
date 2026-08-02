{...}: {
  flake.modules.nixos.openvpn = {pkgs, ...}: {
    environment.systemPackages = [pkgs.openvpn];

    # The NetworkManager plugin allows importing .ovpn profiles as regular
    # connections, so they can be brought up without running openvpn as root.
    networking.networkmanager.plugins = [pkgs.networkmanager-openvpn];
  };
}
