{
  config,
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
  environment.persistence."/persist/system" = lib.mkIf isImpermanent {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/tailscale"
      "/var/lib/NetworkManager"
    ];
  };
  home-manager.users.farlion.home.persistence."/persist" = lib.mkIf config.home-manager.extraSpecialArgs.isImpermanent {
    directories = [
      ".config/tailscale" # Tailscale known hosts
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
  services.tailscale.package = pkgs.unstable.tailscale;
  services.tailscale.useRoutingFeatures = "client";

  # Allow for dynamic hosts file override (by root)
  environment.etc.hosts.mode = "0644";

  networking.firewall.allowedTCPPorts = [
    22000 # Syncthing TCP
  ];

  networking.firewall.allowedUDPPorts = [
    22000 # Syncthing QUIC
    21027 # Syncthing discovery broadcasts on IPv4 and multicasts on IPv6
  ];

  # BBR -> Better performance over weak/jittery links
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  networking.networkmanager = {
    enable = true;
  };
  users.users.farlion.extraGroups = ["networkmanager"];

  # IPv6
  networking.enableIPv6 = false;
  boot.kernelParams = ["ipv6.disable=1"];

  # Disabling DHCPCD in favor of NetworkManager
  networking.dhcpcd.enable = false;
  # Only wait for a single interface to come up
  systemd.network.wait-online.anyInterface = true;
}
