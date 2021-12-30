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

  # Tailscale
  services.tailscale.enable = true;
  networking.firewall.allowedUDPPorts = [ 41641 ];
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # Don't wait for dhcpcd while booting on laptops (wifi)
  networking.dhcpcd.wait = lib.mkIf isLaptop "background";
}
