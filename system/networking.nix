{ lib, config, pkgs, ... }:

let
  isLaptop = (config.networking.hostName == "topbox" || config.networking.hostName == "flexbox");
in
{
  # Adapting the rpfilter to ignore Wireguard related traffic
  # See https://nixos.wiki/wiki/WireGuard
  networking.firewall = {
    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;
    # wireguard trips rpfilter up
    extraCommands = ''
      ip46tables -t raw -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      ip46tables -t raw -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t raw -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      ip46tables -t raw -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
    '';
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

  # Don't wait for dhcpcd while booting on laptops (wifi)
  networking.dhcpcd.wait = lib.mkIf isLaptop "background";
}
