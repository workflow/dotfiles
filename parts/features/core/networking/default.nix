{...}: {
  flake.modules.nixos.networking = {
    config,
    lib,
    pkgs,
    ...
  }: let
    # Get the current tailscale ip if tailscale is up
    tailscale-ip = pkgs.writers.writeBashBin "tailscale-ip" (
      builtins.readFile ./_scripts/tailscale-ip.sh
    );
  in {
    environment.persistence."/persist/system" = lib.mkIf config.dendrix.isImpermanent {
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
    services.tailscale = {
      enable = true;
      package = pkgs.unstable.tailscale;
      useRoutingFeatures = "client";
    };

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

    networking.networkmanager.enable = true;
    users.users.farlion.extraGroups = ["networkmanager"];

    # IPv6
    # TODO: Temporarily enabled to allow buggy Hoppscotch to work
    #networking.enableIPv6 = false;
    #boot.kernelParams = ["ipv6.disable=1"];

    # Disabling DHCPCD in favor of NetworkManager
    networking.dhcpcd.enable = false;

    # Captive Browser
    programs.captive-browser = lib.mkIf config.dendrix.isLaptop {
      enable = true;
      bindInterface = false;
    };

    # Only wait for a single interface to come up
    systemd.network.wait-online.anyInterface = true;
  };

  flake.modules.homeManager.networking = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/tailscale" # Tailscale known hosts
      ];
    };
  };
}
