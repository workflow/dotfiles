{
  lib,
  isImpermanent,
  pkgs,
  ...
}: let
  # Get the current tailscale ip if tailscale is up
  tailscale-ip = pkgs.writers.writeBashBin "tailscale-ip" ''
    set -euo pipefail

    isOnline=$(tailscale status --json | jq -r '.Self.Online')
    if [[ "$isOnline" == "true" ]]; then
      tailscaleIp=$(tailscale status --json | jq -r '.Self.TailscaleIPs[0]')
      echo "{\"icon\": \"tailscale_up\", \"text\": \"$tailscaleIp\", \"state\": \"Good\"}"
    else
      echo "{\"icon\": \"tailscale_down\", \"text\": \"\", \"state\": \"Idle\"}"
    fi
  '';
in {
  environment.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/tailscale"
      "/var/lib/NetworkManager"
    ];
  };

  environment.systemPackages = [
    pkgs.pwru # eBPF-based linux kernel networking debugger
    tailscale-ip # Get the current tailscale IP if tailscale is up
  ];

  networking.firewall = {
    # if packets are dropped, they will show up in dmesg
    logReversePathDrops = true;
    logRefusedPackets = true;
    # logRefusedUnicastsOnly = false;
  };

  # Tailscale
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  # Allow for dynamic hosts file override (by root)
  environment.etc.hosts.mode = "0644";

  networking.firewall.allowedTCPPorts = [
    22000 # Syncthing TCP
    53317 # Localsend
  ];

  networking.firewall.allowedUDPPorts = [
    22000 # Syncthing QUIC
    21027 # Syncthing discovery broadcasts on IPv4 and multicasts on IPv6
    53317 # Localsend
  ];

  networking.networkmanager = {
    enable = true;
  };
  users.users.farlion.extraGroups = ["networkmanager"];

  # Prevent IPv6 leaks when using VPNs
  networking.enableIPv6 = false;

  # Disabling DHCPCD in favor of NetworkManager
  networking.dhcpcd.enable = false;
  # Only wait for a single interface to come up
  systemd.network.wait-online.anyInterface = true;
}
