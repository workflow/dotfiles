{
  lib,
  isImpermanent,
  ...
}: {
  environment.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      "/var/lib/dnscrypt-proxy"
    ];
  };

  networking.nameservers = [
    "127.0.0.1" # dnscrypt-proxy2
  ];

  services.resolved = {
    enable = true;
    # DNSSEC is provided by dnscrypt-proxy2 and the wrapper doesn't work, but it still works
    # dnssec = "true";
    # Not currently sure about dnsovertls
    # dnsovertls = "true";
    llmnr = "false"; # https://www.blackhillsinfosec.com/how-to-disable-llmnr-why-you-want-to/
    extraConfig = ''
      MulticastDNS=false
      DNSStubListenerExtra=172.17.0.1
    '';
    fallbackDns = []; # Ensure we always go through dnscrypt-proxy
  };
  networking.networkmanager.dns = "systemd-resolved";

  # DNSSEC / DoH (DNS over HTTPS)
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      block_ipv6 = true; # Better performance, see https://github.com/DNSCrypt/dnscrypt-proxy/wiki/Performance
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
        cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
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
}
