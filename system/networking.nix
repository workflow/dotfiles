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
  services.tailscale.useRoutingFeatures = "client";


  # RMview Remarkable 2 Screensharing
  networking.firewall.allowedUDPPorts = [ 5901 ];

  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-l2tp ];
    dns = "none"; # Make sure networkmanager doesn't override our DNS settings
  };

  networking.nameservers = [
    "127.0.0.1"
    "1.1.1.1"
  ];

  # Prevent IPv6 leaks when using VPNs
  networking.enableIPv6 = false;

  # Disabling DHCPCD in favor of NetworkManager
  networking.dhcpcd.enable = false;
  # Only wait for a single interface to come up
  systemd.network.wait-online.anyInterface = true;

  # DoH (DNS over HTTPS)
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      require_dnssec = true;
      ipv4_servers = true;
      ipv6_servers = false;
      dnscrypt_servers = true;
      doh_servers = true;
      require_nolog = true; # Server must not log user queries (declarative)

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      # Leaving this off should find the fastest one automagically
      # server_names = [ ... ];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  programs.wireshark.enable = true;
  users.users.farlion.extraGroups = [ "wireshark" ];
}
