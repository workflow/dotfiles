{ lib, config, pkgs, ... }:

{
  networking.firewall = {
    # if packets are dropped, they will show up in dmesg
    logReversePathDrops = true;
  };

  networking.extraHosts = ''
    127.0.0.1  redpanda.default
  '';

  # Tailscale
  services.tailscale.enable = true;
  # Strict reverse path filtering breaks Tailscale exit node us and some subnet routing setups.
  networking.firewall.checkReversePath = "loose";

  # RMview Remarkable 2 Screensharing
  networking.firewall.allowedUDPPorts = [ 5901 ];

  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-l2tp ];
  };

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "100.100.100.100" # Tailscale Magic DNS
  ];

  # Prevent IPv6 leaks when using VPNs
  networking.enableIPv6 = false;

  # Don't wait for dhcpcd while booting
  networking.dhcpcd.wait = "background";
  # Only wait for a single interface to come up
  systemd.network.wait-online.anyInterface = true;
}
