{...}: {
  flake.modules.nixos.dns = {...}: {
    services.resolved = {
      enable = true;
      llmnr = "false";
      extraConfig = ''
        MulticastDNS=false
        DNSStubListenerExtra=172.17.0.1
      '';
      fallbackDns = [];
    };
    networking.networkmanager.dns = "systemd-resolved";
  };
}
