{...}: {
  flake.modules.nixos.dns = {...}: {
    services.resolved = {
      enable = true;
      settings.Resolve = {
        LLMNR = "false"; # https://www.blackhillsinfosec.com/how-to-disable-llmnr-why-you-want-to/
        MulticastDNS = "false";
        DNSStubListenerExtra = "172.17.0.1";
        FallbackDNS = ""; # Ensure we always go through the configured DNS, no magic defaults
      };
    };
    networking.networkmanager.dns = "systemd-resolved";
  };
}
